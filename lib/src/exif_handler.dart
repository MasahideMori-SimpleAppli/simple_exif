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
  // value : tag data class.
  final Map<int, ExifType> _exifData = {};

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
        // 不正なセグメント長の場合は終了する。
        return;
      }
      // APP1セグメントを探す
      if (marker == 0xE1) {
        // APP1セグメントのExifヘッダーを確認
        final exifHeader = bytes.sublist(
            offset + markerLength + segmentLengthBytes,
            offset + markerLength + segmentLengthBytes + exifIdentifierLength);
        if (String.fromCharCodes(exifHeader) == 'Exif\x00\x00') {
          // Exifデータを解析して終了する
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

  /// Exifセグメントを解析し、_exifDataに格納する
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  void _parseExifSegment(Uint8List exifSegment) {
    // TIFFヘッダーの確認
    bool isBigEndian = String.fromCharCodes(exifSegment.sublist(0, 2)) == 'MM';
    // オフセットを計算
    int ifdOffset = _readUint32(exifSegment, 4, isBigEndian);
    // IFD（Image File Directory）の解析
    _parseIFD(exifSegment, ifdOffset, isBigEndian);
  }

  /// IFDを解析してタグを取得
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  void _parseIFD(Uint8List exifSegment, int offset, bool isBigEndian) {
    final int numberOfEntries = _readUint16(exifSegment, offset, isBigEndian);
    for (int i = 0; i < numberOfEntries; i++) {
      final int entryOffset = offset + 2 + (i * 12);
      final int tagID = _readTagID(exifSegment, entryOffset, isBigEndian);
      ExifType? tagValue =
          _readTagValue(exifSegment, entryOffset, isBigEndian, tagID);
      // タグを格納
      if (tagValue != null) {
        _exifData[tagID] = tagValue;
      }
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
  ExifType? _readTagValue(
      Uint8List exifSegment, int entryOffset, bool isBigEndian, int tagID) {
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
    return _exifData.containsKey(tagID);
  }

  /// (en) Gets a list of all tag IDs.
  ///
  /// (ja) 全てのタグIDをリストで取得します。
  List<int> getAllTagIDs() {
    return _exifData.keys.toList();
  }

  /// (en) Returns the specified tag.
  /// If it doesn't exist, null is returned.
  ///
  /// (ja) 指定したタグを返します。
  /// 存在しない場合はnullが返されます。
  ///
  /// * [tagID] : Target tag id.
  ExifTag? getTag(int tagID) {
    if (_exifData.containsKey(tagID)) {
      return ExifTag.custom(tagID, _exifData[tagID]!);
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
    _exifData[tag.id] = tag.value;
  }

  /// (en) Remove the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を削除します。
  ///
  /// * [tagID] : The tag id.
  void removeTag(int tagID) {
    _exifData.remove(tagID);
  }

  /// (en) Delete all Exif data.
  ///
  /// (ja) 全てのExif情報を削除します。
  void deleteExifData() {
    _exifData.clear();
  }

  /// 現在保持しているExifデータをUint8List形式に戻します。
  /// つまり、このクラス内に格納された情報からExifセグメントを再構成します。
  /// 戻り値にはExif識別子とTiffデータのみが含まれ、APP1マーカーやセグメント長は含まれません。
  /// * [endian] : Endianness when writing.
  Uint8List? toBytes({Endian endian = Endian.big}) {
    if (_exifData.isEmpty) {
      return null; // データがない場合はnullを返す
    }
    // 1. TIFFヘッダーを作成する
    final tiffHeader = BytesBuilder();
    tiffHeader
        .add(endian == Endian.big ? [0x4D, 0x4D] : [0x49, 0x49]); // MMまたはII
    tiffHeader
        .add(endian == Endian.big ? [0x00, 0x2A] : [0x2A, 0x00]); // マジックナンバー
    tiffHeader.add([0x00, 0x00, 0x00, 0x08]); // IFDの開始位置

    // 2. IFDエントリを作成する
    final ifdEntries = BytesBuilder();
    final dataBlock = BytesBuilder();
    int dataOffset = tiffHeader.length +
        2 +
        _exifData.length * 12 +
        4; // TIFFヘッダー + エントリ数 + IFDエントリ + 終端

    for (MapEntry<int, ExifType> entry in _exifData.entries) {
      final int tagID = entry.key;
      final ExifType tagValue = entry.value;
      final Uint8List? tagBytes = tagValue.toUint8List(endian: endian);
      if (tagBytes != null) {
        final int dataType = tagValue.dataType.toInt();
        final int dataCount =
            tagBytes.length ~/ ExifHandler.dataTypeSize[dataType]!;
        ifdEntries.add(_writeUint16(tagID)); // タグID
        ifdEntries.add(_writeUint16(dataType)); // データ型
        ifdEntries.add(_writeUint32(dataCount)); // データ数
        if (tagBytes.length <= 4) {
          ifdEntries.add(tagBytes); // 値を直接書き込む
          ifdEntries.add(Uint8List(4 - tagBytes.length)); // パディング
        } else {
          ifdEntries.add(_writeUint32(dataOffset)); // データオフセット
          dataBlock.add(tagBytes); // データを後ろに追加
          dataOffset += tagBytes.length; // オフセットを更新
        }
      }
    }

    // 終端マーカー（次のIFDのオフセット、通常は0）
    ifdEntries.add([0x00, 0x00, 0x00, 0x00]);

    // 3. バイト列を結合する
    final tiffData = BytesBuilder();
    tiffData.add(tiffHeader.toBytes());
    tiffData.add(_writeUint16(_exifData.length)); // IFDエントリ数
    tiffData.add(ifdEntries.toBytes());
    tiffData.add(dataBlock.toBytes());

    // 4. 必要なデータを結合して返す。
    final exifSegment = BytesBuilder();
    exifSegment.add(Uint8List.fromList('Exif\x00\x00'.codeUnits)); // Exif識別子
    exifSegment.add(tiffData.toBytes()); // TIFFデータ

    return exifSegment.toBytes();
  }

  Uint8List _writeUint16(int value) {
    return Uint8List(2)..buffer.asByteData().setUint16(0, value, Endian.big);
  }

  Uint8List _writeUint32(int value) {
    return Uint8List(4)..buffer.asByteData().setUint32(0, value, Endian.big);
  }
}
