import 'dart:typed_data';
import 'package:simple_exif/simple_exif.dart';
import 'package:simple_exif/src/util_exif_tag_name.dart';

/// (en) This is an inner class that analyzes, stores and
/// manipulates the entire Exif data.
/// This class may only be called from within this package.
///
/// (ja) これは、Exif データ全体を分析、保存、操作する内部クラスです。
/// このクラスは、このパッケージ内からのみ呼び出されます。
class ExifHandler {
  final Map<String, ExifType?> _exifData = {};

  // 定数定義
  static const int markerLength = 2; // セグメントマーカーの長さ (例: 0xFFE1)
  static const int segmentLengthBytes = 2; // セグメント長を示す2バイト
  static const int exifIdentifierLength = 6; // 'Exif\x00\x00' の長さ
  static const int tiffHeaderOffset =
      markerLength + segmentLengthBytes + exifIdentifierLength;

  // 8 bit = 1.
  static const Map<int, int> dataTypeSize = {
    1: 1, // BYTE
    2: 1, // ASCII
    3: 2, // SHORT
    4: 4, // LONG
    5: 8, // RATIONAL (2 LONG values: numerator and denominator)
    7: 1, // UNDEFINED (Equal ASCII)
    9: 4, // SLONG
    10: 8, // SRATIONAL
  };

  /// Exifセグメントを解析して_mapExifDataに格納します。
  ExifHandler.fromBytes(Uint8List bytes) {
    // バイトデータがJPEGファイルか確認
    if (bytes.length < markerLength || bytes[0] != 0xFF || bytes[1] != 0xD8) {
      throw ArgumentError('Invalid JPEG file.');
    }
    int offset = markerLength; // SOIマーカーの次から解析を開始
    while (offset < bytes.length) {
      if (bytes[offset] != 0xFF) {
        throw ArgumentError('Invalid marker at offset $offset.');
      }
      int marker = bytes[offset + 1];
      int segmentLength = _readUint16(bytes, offset + markerLength, true);
      // APP1セグメントか確認
      if (marker == 0xE1) {
        // EXIFヘッダーをチェック
        if (String.fromCharCodes(bytes.sublist(
                offset + markerLength + segmentLengthBytes,
                offset +
                    markerLength +
                    segmentLengthBytes +
                    exifIdentifierLength)) ==
            'Exif\x00\x00') {
          _parseExifSegment(bytes.sublist(offset + tiffHeaderOffset,
              offset + tiffHeaderOffset + segmentLength - segmentLengthBytes));
          return;
        }
      }
      // 次のセグメントに進む
      offset += markerLength + segmentLength;
    }
    throw ArgumentError('No EXIF data found.');
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
    int numberOfEntries = _readUint16(exifSegment, offset, isBigEndian);
    for (int i = 0; i < numberOfEntries; i++) {
      int entryOffset = offset + 2 + (i * 12);
      String? tagName = _readTagName(exifSegment, entryOffset, isBigEndian);
      // このパッケージが非対応のタグ(Exif 2.3に定義されていないもの)の場合はスキップする。
      if (tagName != null) {
        dynamic tagValue = _readTagValue(exifSegment, entryOffset, isBigEndian);
        // タグを格納
        _exifData[tagName] = tagValue;
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

  /// タグ番号を読み取り、タグ名に変換して返す。
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  /// * [entryOffset] : タグの格納されているオフセット。
  /// * [isBigEndian] : TIFFのエンディアン情報。
  String? _readTagName(
      Uint8List exifSegment, int entryOffset, bool isBigEndian) {
    int tagId = _readUint16(exifSegment, entryOffset, isBigEndian);
    return UtilExifTagName.convertFromHexStr(
        tagId.toRadixString(16).padLeft(4, '0'));
  }

  /// タグ値を読み取るヘルパー関数。
  /// データ型が未定義の場合や、範囲外アクセスが発生するケースではnullが返されます。
  /// それ以外はこのパッケージで定義されたExifTypeの専用クラスが返されます。
  /// * [exifSegment] : Exifセグメント全体（Exif情報のみ）のバイトコード。
  /// * [entryOffset] : タグの格納されているオフセット。
  /// * [isBigEndian] : TIFFのエンディアン情報。
  ExifType? _readTagValue(
      Uint8List exifSegment, int entryOffset, bool isBigEndian) {
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
  /// * [tag] : The target tag.
  bool containsOf(String tag) {
    return _exifData.containsKey(tag);
  }

  /// (en) Gets a list of all tag names.
  ///
  /// (ja) 全てのタグ名をリストで取得します。
  List<String> getAllTagNames() {
    return _exifData.keys.toList();
  }

  /// (en) Returns the specified tag.
  ///
  /// (ja) 指定したタグを返します。
  ///
  /// * [tagName] : Target tag name.
  ExifTag getTag(String tagName) {
    return ExifTag.custom(tagName, _exifData[tagName]);
  }

  /// (en) Rewrites the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を書き換えます。
  ///
  /// * [tag] : For type safety, pass overriding data in a dedicated class.
  void updateTag(ExifTag tag) {
    _exifData[tag.name] = tag.value;
  }

  /// (en) Remove the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を削除します。
  ///
  /// * [tagName] : The tag name.
  void removeTag(String tagName) {
    _exifData.remove(tagName);
  }

  /// (en) Delete all Exif data.
  ///
  /// (ja) 全てのExif情報を削除します。
  void deleteExifData() {
    _exifData.clear();
  }

  /// 現在保持しているExifデータをUint8List形式に戻します。
  Uint8List? toBytes() {
    if (_exifData.isEmpty) {
      return null;
    } else {
      // TODO
    }
  }
}
