import 'dart:typed_data';
import '../../simple_exif.dart';

/// (en) This is an inner class that analyzes, stores and
/// manipulates the entire Exif data.
/// This class may only be called from within this package.
///
/// (ja) これは、Exif データ全体を分析、保存、操作する内部クラスです。
/// このクラスは、このパッケージ内からのみ呼び出されます。
class ExifHandler {
  // key : tagID.
  // value : tag class.
  final Map<int, ExifTag> _tags = {};

  // 定数定義
  static const int markerLength = 2; // セグメントマーカーの長さ (例: 0xFFE1)
  static const int segmentLengthBytes = 2; // セグメント長を示す2バイト
  static const int exifIdentifierLength = 6; // 'Exif\x00\x00' の長さ
  static const int tiffHeaderOffset =
      markerLength + segmentLengthBytes + exifIdentifierLength;

  // key : dataType code
  // value : dataType size. 8 bit = 1.
  static const Map<int, int> dataTypeSize = {
    1: 1, // BYTE
    2: 1, // ASCII
    3: 2, // SHORT
    4: 4, // LONG
    5: 8, // RATIONAL (2 LONG values: numerator and denominator)
    7: 1, // UNDEFINED (Tag-specific bytecode)
    9: 4, // SLONG
    10: 8, // SRATIONAL
    11: 4, // FLOAT (TIFF)
    12: 8, // Double (TIFF)
  };

  /// Exifセグメントを解析して_mapExifDataに格納します。
  ExifHandler.fromBytes(Uint8List bytes) {
    // JPEGファイル形式の最小要件を確認し、JPEG以外ならエラーを出す。
    if (bytes.length < markerLength || bytes[0] != 0xFF || bytes[1] != 0xD8) {
      throw ArgumentError('Invalid JPEG file.');
    }
    int offset = markerLength; // SOIマーカーの次から解析を開始
    while (offset < bytes.length) {
      // 最低限のバリデーション: マーカーがJPEG仕様に準拠しているかのチェック
      if (offset + markerLength >= bytes.length || bytes[offset] != 0xFF) {
        // セグメントが正しくない場合はExifが無いと見なして終了する。
        return;
      }
      int marker = bytes[offset + 1];
      int segmentLength = _readUint16(bytes, offset + 2, true);
      // セグメント長がファイルサイズを超えないか確認
      if (offset + markerLength + segmentLength > bytes.length) {
        // 不正なセグメント長の場合はエラーを出す。
        throw ArgumentError('This is broken JPEG file.');
      }
      // APP1セグメント（このプログラムでは1個目のみに対応している）を探す
      if (marker == 0xE1) {
        // APP1セグメントのExifヘッダーを確認
        final exifHeader = bytes.sublist(
            offset + markerLength + segmentLengthBytes,
            offset + markerLength + segmentLengthBytes + exifIdentifierLength);
        if (String.fromCharCodes(exifHeader) == 'Exif\x00\x00') {
          // Exifデータ（TIFFヘッダーから）を解析して終了する
          _parseExifSegment(bytes.sublist(offset + tiffHeaderOffset,
              offset + tiffHeaderOffset + segmentLength - segmentLengthBytes));
          return;
        }
      }
      // 次のセグメントに進む
      offset += markerLength + segmentLength;
    }
    // Exifが見つからない場合は単に終了する。
    return;
  }

  /// Exifセグメントを解析し、_exifDataに格納する。
  /// なお、0th IFDのみを解析する。
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  void _parseExifSegment(Uint8List exifSegment) {
    // TIFFヘッダーの確認
    bool isBigEndian = String.fromCharCodes(exifSegment.sublist(0, 2)) == 'MM';
    // オフセットを計算
    int ifdOffset = _readUint32(exifSegment, 4, isBigEndian);
    // IFD（Image File Directory）の解析。最初はTIFF領域からになる。
    _parseIFD(exifSegment, ifdOffset, isBigEndian, EnumIFDType.tiff);
  }

  /// IFDを解析してタグを取得
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  /// * [offset] : 読み取り開始オフセット。
  /// * [isBigEndian] : エンディアン情報。
  /// * [idfType] : IFDの種類。これを正しく設定することで、保存時に正しい位置にデータを格納可能になる。
  void _parseIFD(Uint8List exifSegment, int offset, bool isBigEndian,
      EnumIFDType ifdType) {
    final int numberOfEntries = _readUint16(exifSegment, offset, isBigEndian);
    // Exif IFD Pointer (tag ID: 34665) のオフセット
    int? exifIFDOffset;
    // GPS Info IFD Pointer (tag ID: 34853) のオフセット
    int? gpsInfoOffset;
    // Interoperability IFD Pointer (tag ID: 40965) のオフセット
    int? interoperabilityOffset;
    for (int i = 0; i < numberOfEntries; i++) {
      final int entryOffset = offset + 2 + (i * 12);
      final int tagID = _readTagID(exifSegment, entryOffset, isBigEndian);
      ExifDataType? tagValue =
          _readTagValue(exifSegment, entryOffset, isBigEndian, tagID, ifdType);
      // タグを格納
      if (tagValue != null) {
        _tags[tagID] = ExifTag.custom(tagID, tagValue, ifdType);
      }
      // Exif IFD Pointer を確認し、存在する場合は追加処理を行うために位置をバッファする。
      if (tagID == 34665) {
        exifIFDOffset =
            _readUint32(exifSegment, entryOffset + 8, isBigEndian); // ポインター取得
      }
      // Interoperability (IO) IFD Pointer を確認し、存在する場合は追加処理を行うために位置をバッファする。
      if (tagID == 40965) {
        interoperabilityOffset =
            _readUint32(exifSegment, entryOffset + 8, isBigEndian); // ポインター取得
      }
      // GPS Info IFD Pointer を確認し、存在する場合は追加処理を行うために位置をバッファする。
      if (tagID == 34853) {
        gpsInfoOffset =
            _readUint32(exifSegment, entryOffset + 8, isBigEndian); // ポインター取得
      }
    }
    // Exif IFD Pointerが存在する場合は再帰的に解析
    if (exifIFDOffset != null) {
      _parseIFD(exifSegment, exifIFDOffset, isBigEndian, EnumIFDType.exif);
    }
    // GPS Info IFD Pointerが存在する場合は再帰的に解析
    if (gpsInfoOffset != null) {
      _parseIFD(exifSegment, gpsInfoOffset, isBigEndian, EnumIFDType.gps);
    }
    // Interoperability IFD Pointerが存在する場合は再帰的に解析
    if (interoperabilityOffset != null) {
      _parseIFD(exifSegment, interoperabilityOffset, isBigEndian,
          EnumIFDType.interoperability);
    }
  }

  /// ヘルパー関数: 8ビット値を読み取る
  int _readUint8(Uint8List data, int offset) {
    // 8ビット値の読み取りはエンディアンに影響されない。
    return data[offset];
  }

  /// ヘルパー関数: 16ビット値を読み取る
  int _readUint16(Uint8List data, int offset, bool isBigEndian) {
    if (isBigEndian) {
      return (data[offset] << 8) | data[offset + 1];
    } else {
      return (data[offset + 1] << 8) | data[offset];
    }
  }

  /// ヘルパー関数: 32ビット値を読み取る
  int _readUint32(Uint8List data, int offset, bool isBigEndian) {
    if (isBigEndian) {
      return (data[offset] << 24) |
          (data[offset + 1] << 16) |
          (data[offset + 2] << 8) |
          data[offset + 3];
    } else {
      return (data[offset + 3] << 24) |
          (data[offset + 2] << 16) |
          (data[offset + 1] << 8) |
          data[offset];
    }
  }

  /// ヘルパー関数: 32ビットの浮動小数点値を読み取る
  double _readFloat32(Uint8List data, int offset, bool isBigEndian) {
    ByteData byteData = ByteData.sublistView(data, offset, offset + 4);
    return byteData.getFloat32(0, isBigEndian ? Endian.big : Endian.little);
  }

  /// ヘルパー関数: 64ビットの浮動小数点値を読み取る
  double _readFloat64(Uint8List data, int offset, bool isBigEndian) {
    ByteData byteData = ByteData.sublistView(data, offset, offset + 8);
    return byteData.getFloat64(0, isBigEndian ? Endian.big : Endian.little);
  }

  /// タグIDを読み取って返します。
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  /// * [entryOffset] : タグの格納されているオフセット。
  /// * [isBigEndian] : TIFFのエンディアン情報。
  int _readTagID(Uint8List exifSegment, int entryOffset, bool isBigEndian) {
    return _readUint16(exifSegment, entryOffset, isBigEndian);
  }

  /// タグ値を読み取るヘルパー関数。
  /// データ型が未定義の場合や、範囲外アクセスが発生するケースではnullが返されます。
  /// それ以外はこのパッケージで定義されたExifTypeの専用クラスが返されます。
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  /// * [entryOffset] : タグの格納されているオフセット。
  /// * [isBigEndian] : TIFFのエンディアン情報。
  /// * [tagID] : tag id.
  ExifDataType? _readTagValue(Uint8List exifSegment, int entryOffset,
      bool isBigEndian, int tagID, EnumIFDType ifdType) {
    try {
      // データ型を取得 (2バイト)
      final int dataType =
          _readUint16(exifSegment, entryOffset + 2, isBigEndian);
      // データ数を取得 (4バイト)
      final int dataCount =
          _readUint32(exifSegment, entryOffset + 4, isBigEndian);
      // 値または値へのオフセットを取得 (4バイト)
      final int valueOffset =
          _readUint32(exifSegment, entryOffset + 8, isBigEndian);
      // データ型が未定義の場合
      if (!dataTypeSize.containsKey(dataType)) {
        return null; // 未知の型
      }
      // 8bitを1とした時のデータサイズを計算
      final int dataSize = dataTypeSize[dataType]! * dataCount;
      // 値がオフセットで指定されているか直接含まれているかを判定
      late final Uint8List valueBytes;
      if (dataSize <= 4) {
        // エントリ内に直接格納されている場合
        valueBytes =
            exifSegment.sublist(entryOffset + 8, entryOffset + 8 + dataSize);
      } else {
        // オフセット先にデータが格納されている場合
        valueBytes = exifSegment.sublist(valueOffset, valueOffset + dataSize);
      }
      // データ型に応じて値を解析
      if (dataCount == 1) {
        switch (dataType) {
          case 1: // BYTE
            return ExifByte(_readUint8(valueBytes, 0));
          case 2: // ASCII
            // NULL終端を除いたテキストデータのため、空文字になる。
            return ExifAsciiCodeArray("");
          case 3: // SHORT
            return ExifShort(_readUint16(valueBytes, 0, isBigEndian));
          case 4: // LONG
            return ExifLong(_readUint32(valueBytes, 0, isBigEndian));
          case 5: // RATIONAL
            return ExifRational(
                ExifLong(_readUint32(valueBytes, 0, isBigEndian)),
                ExifLong(_readUint32(valueBytes, 4, isBigEndian)));
          case 7: // UNDEFINED
            return ExifUndefined(valueBytes); // バイト列として返す
          case 9: // SLONG
            return ExifSLong(_readUint32(valueBytes, 0, isBigEndian));
          case 10: // SRATIONAL
            return ExifSRational(
                ExifSLong(_readUint32(valueBytes, 0, isBigEndian)),
                ExifSLong(_readUint32(valueBytes, 4, isBigEndian)));
          case 11: // FLOAT
            return ExifFloat(_readFloat32(valueBytes, 0, isBigEndian));
          case 12: //DOUBLE
            return ExifDouble(_readFloat64(valueBytes, 0, isBigEndian));
          default:
            return null; // 未知のデータ型
        }
      } else {
        switch (dataType) {
          case 1: // BYTE
            final List<ExifByte> values = [];
            for (int i = 0; i < dataCount; i++) {
              values.add(ExifByte(_readUint8(valueBytes, i)));
            }
            return ExifByteArray(values);
          case 2: // ASCII
            // NULL終端を除いたテキストデータを読み出す
            final String asciiString =
                String.fromCharCodes(valueBytes.take(dataCount - 1));
            return ExifAsciiCodeArray(asciiString);
          case 3: // SHORT
            final List<ExifShort> values = [];
            for (int i = 0; i < dataCount; i++) {
              values
                  .add(ExifShort(_readUint16(valueBytes, i * 2, isBigEndian)));
            }
            return ExifShortArray(values);
          case 4: // LONG
            final List<ExifLong> values = [];
            for (int i = 0; i < dataCount; i++) {
              values.add(ExifLong(_readUint32(valueBytes, i * 4, isBigEndian)));
            }
            return ExifLongArray(values);
          case 5: // RATIONAL
            final List<ExifRational> values = [];
            for (int i = 0; i < dataCount; i++) {
              values.add(ExifRational(
                  ExifLong(_readUint32(valueBytes, i * 8, isBigEndian)),
                  ExifLong(_readUint32(valueBytes, i * 8 + 4, isBigEndian))));
            }
            return ExifRationalArray(values);
          case 7: // UNDEFINED
            return ExifUndefined(valueBytes); // バイト列として返す
          case 9: // SLONG
            final List<ExifSLong> values = [];
            for (int i = 0; i < dataCount; i++) {
              values
                  .add(ExifSLong(_readUint32(valueBytes, i * 4, isBigEndian)));
            }
            return ExifSLongArray(values);
          case 10: // SRATIONAL
            final List<ExifSRational> values = [];
            for (int i = 0; i < dataCount; i++) {
              values.add(ExifSRational(
                  ExifSLong(_readUint32(valueBytes, i * 8, isBigEndian)),
                  ExifSLong(_readUint32(valueBytes, i * 8 + 4, isBigEndian))));
            }
            return ExifSRationalArray(values);
          case 11: // FLOAT
            final List<ExifFloat> values = [];
            for (int i = 0; i < dataCount; i++) {
              values
                  .add(ExifFloat(_readFloat32(valueBytes, i * 4, isBigEndian)));
            }
            return ExifFloatArray(values);
          case 12: //DOUBLE
            final List<ExifDouble> values = [];
            for (int i = 0; i < dataCount; i++) {
              values.add(
                  ExifDouble(_readFloat64(valueBytes, i * 8, isBigEndian)));
            }
            return ExifDoubleArray(values);
          default:
            return null; // 未知のデータ型
        }
      }
    } catch (e) {
      return null;
    }
  }

  /// (en) Returns true if the specified tag exists.
  ///
  /// (ja) 指定したタグが存在するならtrueを返します。
  ///
  /// * [tagID] : The target tag id.
  bool containsOf(int tagID) {
    return _tags.containsKey(tagID);
  }

  /// (en) Gets a list of all tag IDs.
  ///
  /// (ja) 全てのタグIDをリストで取得します。
  List<int> getAllTagIDs() {
    return _tags.keys.toList();
  }

  /// (en) Returns the specified tag.
  /// If it doesn't exist, null is returned.
  /// Note that the data returned is not a copy.
  ///
  /// (ja) 指定したタグを返します。
  /// 存在しない場合はnullが返されます。
  /// 返されるデータはコピーではないので注意してください。
  ///
  /// * [tagID] : Target tag id.
  ExifTag? getTag(int tagID) {
    if (_tags.containsKey(tagID)) {
      return _tags[tagID]!;
    } else {
      return null;
    }
  }

  /// (en) Updates the specified tag.
  ///
  /// (ja) 指定したタグを更新します。
  ///
  /// * [tag] : For type safety, pass overriding data in a dedicated class.
  void updateTag(ExifTag tag) {
    _tags[tag.id] = tag;
  }

  /// (en) Remove the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を削除します。
  ///
  /// * [tagID] : The tag id.
  void removeTag(int tagID) {
    _tags.remove(tagID);
  }

  /// (en) Delete all Exif data.
  ///
  /// (ja) 全てのExif情報を削除します。
  void deleteExifData() {
    _tags.clear();
  }

  // /// TIFFタグのうち、Exif、IO、GPSのオフセットを除くタグを取得します。
  // List<ExifTag> _getTiffTagsWithoutOffset() {
  //   List<ExifTag> r = [];
  //   for (ExifTag i in _tags.values) {
  //     if (i.ifdType == EnumIFDType.tiff) {
  //       // Exif IFD Pointer, Interoperability IFD Pointer, GPS Info IFD Pointer
  //       if (i.id == 34665 || i.id == 40965 || i.id == 34853) {
  //         continue;
  //       }
  //       else {
  //         r.add(i);
  //       }
  //     }
  //   }
  //   return r;
  // }
  //
  // List<ExifTag> _getExifTags() {
  //   List<ExifTag> r = [];
  //   for (ExifTag i in _tags.values) {
  //     if (i.ifdType == EnumIFDType.exif) {
  //       r.add(i);
  //     }
  //   }
  //   return r;
  // }
  //
  // /// IO Tag
  // List<ExifTag> _getInteroperabilityTags() {
  //   List<ExifTag> r = [];
  //   for (ExifTag i in _tags.values) {
  //     if (i.ifdType == EnumIFDType.interoperability) {
  //       r.add(i);
  //     }
  //   }
  //   return r;
  // }
  //
  // List<ExifTag> _getGPSTags() {
  //   List<ExifTag> r = [];
  //   for (ExifTag i in _tags.values) {
  //     if (i.ifdType == EnumIFDType.gps) {
  //       r.add(i);
  //     }
  //   }
  //   return r;
  // }

  //
  // 作成中。
  //
  // /// 現在保持しているExifデータをUint8List形式に戻します。
  // /// つまり、このクラス内に格納された情報からExifセグメントを再構成します。
  // /// 戻り値にはExif識別子とTiffデータのみが含まれ、APP1マーカーやセグメント長は含まれません。
  // /// * [endian] : Endianness when writing.
  // Uint8List? toBytes({Endian endian = Endian.big}) {
  //   if (_tags.isEmpty) {
  //     return null; // データがない場合はnullを返す
  //   }
  //   // 1. TIFFヘッダーを作成
  //   final tiffHeader = BytesBuilder();
  //   tiffHeader
  //       .add(endian == Endian.big ? [0x4D, 0x4D] : [0x49, 0x49]); // MMまたはII
  //   tiffHeader
  //       .add(endian == Endian.big ? [0x00, 0x2A] : [0x2A, 0x00]); // マジックナンバー
  //   tiffHeader.add([0x00, 0x00, 0x00, 0x08]); // IFDの開始位置
  //
  //   // 書き込み用のビルダーを準備。
  //   final ifdData = BytesBuilder();
  //
  //   // 各タグを取得
  //   final List<ExifTag> tiffTags = _getTiffTagsWithoutOffset();
  //   final List<ExifTag> exifTags = _getExifTags();
  //   final List<ExifTag> interoperabilityTags = _getInteroperabilityTags();
  //   final List<ExifTag> gpsTags = _getGPSTags();
  //
  //   // 追加のIFDがある場合はその分のタグ追加数を事前に計算する。
  //   int tiffTagCount = tiffTags.length;
  //   if (exifTags.isNotEmpty) {
  //     tiffTagCount += 1;
  //   }
  //   if (interoperabilityTags.isNotEmpty) {
  //     tiffTagCount += 1;
  //   }
  //   if (gpsTags.isNotEmpty) {
  //     tiffTagCount += 1;
  //   }
  //
  //   // 各データのバッファ先を準備。
  //   final tiffEntries = BytesBuilder();
  //   final tiffDataBlock = BytesBuilder();
  //   // 最初のオフセットを設定。
  //   int tiffDataOffset = tiffHeader.length + 2 + tiffTagCount * 12 +
  //       4; // TIFFヘッダー + エントリ数 + タグエントリの長さ + 終端
  //
  //   // 2. 0th IFDエントリを作成
  //   if (tiffTags.isNotEmpty) {
  //     for (ExifTag i in tiffTags) {
  //       final int dataType = i.value.dataType.toInt();
  //       final Uint8List tagBytes = i.value.toUint8List(endian: endian);
  //       final int dataCount = tagBytes.length ~/
  //           ExifHandler.dataTypeSize[dataType]!;
  //       // TIFFエントリの作成
  //       tiffEntries.add(_writeUint16(i.id)); // タグID
  //       tiffEntries.add(_writeUint16(dataType)); // データ型
  //       tiffEntries.add(_writeUint32(dataCount)); // データ数
  //       if (tagBytes.length <= 4) {
  //         // データが4バイト以内の場合はタグに直接埋め込む
  //         tiffEntries.add(tagBytes); // 値を直接書き込む
  //         tiffEntries.add(Uint8List(4 - tagBytes.length)); // パディング
  //       } else {
  //         // データが4バイトより大きい場合はオフセットを追加
  //         tiffEntries.add(_writeUint32(tiffDataOffset)); // データオフセット
  //         tiffDataBlock.add(tagBytes); // 実際のデータを後ろに追加
  //         tiffDataOffset += tagBytes.length; // オフセット更新
  //       }
  //     }
  //   }
  //
  //   // 3. Exif IFDエントリを作成
  //   if (exifTags.isNotEmpty) {
  //     // TIFFタグにオフセットを追加。
  //     ExifTag exifOffset = ExifTag.custom(
  //         34665, ExifLong(tiffDataOffset), EnumIFDType.tiff);
  //     final int eoDataType = exifOffset.value.dataType.toInt();
  //     final Uint8List eoTagBytes = exifOffset.value.toUint8List(endian: endian);
  //     final int eoDataCount = eoTagBytes.length ~/
  //         ExifHandler.dataTypeSize[eoDataType]!;
  //     tiffEntries.add(_writeUint16(exifOffset.id)); // タグID
  //     tiffEntries.add(_writeUint16(eoDataType)); // データ型
  //     tiffEntries.add(_writeUint32(eoDataCount)); // データ数
  //
  //   }
  //
  //   // ifdDataに追加
  //   ifdData.add(tiffHeader.toBytes()); // TIFFヘッダーを追加。
  //   ifdData.add(_writeUint16(tiffTagCount)); // TIFFタグ（エントリ）の数を追加
  //   ifdData.add(tiffEntries.toBytes()); // TIFFエントリを追加
  //   ifdData.add(tiffDataBlock.toBytes()); // データブロックを追加
  //
  //   final exifSegment = BytesBuilder();
  //   exifSegment.add(Uint8List.fromList('Exif\x00\x00'.codeUnits)); // Exif識別子
  //   exifSegment.add(ifdData.toBytes());
  //   return exifSegment.toBytes();
  // }
  //
  // Uint8List _writeUint16(int value) {
  //   return Uint8List(2)
  //     ..buffer.asByteData().setUint16(0, value, Endian.big);
  // }
  //
  // Uint8List _writeUint32(int value) {
  //   return Uint8List(4)
  //     ..buffer.asByteData().setUint32(0, value, Endian.big);
  // }
}
