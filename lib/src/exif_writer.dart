import 'dart:typed_data';
import 'exif_handler.dart';
import 'exif_tag.dart';

/// (en) 画像のExifデータを書き換えるクラスです。
///
/// (ja) 画像のExifデータを書き換えるためのクラスです。
class ExifWriter {
  late final Uint8List _imgBytes;
  late final ExifHandler _handler;

  /// * [bytes] : The JPEG format image file bytes data.
  ExifWriter(Uint8List bytes) {
    _imgBytes = bytes;
    _handler = ExifHandler.fromBytes(bytes);
  }

  /// (en) Rewrites the content of the specified tag.
  /// This method only updates the Exif information that is stored internally
  /// for subsequent operations,
  /// it does not update the information in the file itself.
  /// Call the save method to get the edited file.
  ///
  /// (ja) 指定したタグの内容を書き換えます。
  /// このメソッドは、連続的な操作のために内部的に保持するExif情報だけを更新し、
  /// ファイル本体の情報は更新しません。
  /// 編集後のファイルを得るにはsaveメソッドを呼び出してください。
  ///
  /// * [tag] : For type safety, pass overriding data in a dedicated class.
  void updateTag(ExifTag tag) {
    _handler.updateTag(tag);
  }

  /// (en) Deletes the content of the specified tag.
  /// This method only updates the Exif information that is stored internally
  /// for subsequent operations,
  /// it does not update the information in the file itself.
  /// Call the save method to get the edited file.
  ///
  /// (ja) 指定したタグの内容を削除します。
  /// このメソッドは、連続的な操作のために内部的に保持するExif情報だけを更新し、
  /// ファイル本体の情報は更新しません。
  /// 編集後のファイルを得るにはsaveメソッドを呼び出してください。
  ///
  /// * [tagID] : Target tag id.
  void removeTag(int tagID) {
    _handler.removeTag(tagID);
  }

  /// (en) Delete all Exif data.
  /// This method only updates the Exif information that is stored internally
  /// for subsequent operations,
  /// it does not update the information in the file itself.
  /// Call the save method to get the edited file.
  ///
  /// (ja) 全てのExif情報を削除します。
  /// このメソッドは、連続的な操作のために内部的に保持するExif情報だけを更新し、
  /// ファイル本体の情報は更新しません。
  /// 編集後のファイルを得るにはsaveメソッドを呼び出してください。
  void deleteExifData() {
    _handler.deleteExifData();
  }

  /// (en) Gets image data with Exif information edited by
  /// the methods of this class.
  ///
  /// (ja) このクラスのメソッドによって編集されたExif情報を持つ
  /// 画像データを取得します。
  Uint8List save() {
    // newExifBytesの内容はExif識別子 + TIFFデータのみ。
    final Uint8List? newExifBytes = _handler.toBytes();
    const soiMarker = [0xFF, 0xD8]; // JPEGファイルの先頭マーカー
    const app1Marker = [0xFF, 0xE1]; // Exifセグメントのマーカー
    // JPEGの先頭が正しいか確認
    if (_imgBytes.length < 4 ||
        _imgBytes[0] != soiMarker[0] ||
        _imgBytes[1] != soiMarker[1]) {
      throw const FormatException('Invalid JPEG file format');
    }
    int offset = 2; // SOIの直後から探索開始
    while (offset < _imgBytes.length - 4) {
      // マーカーを確認
      if (_imgBytes[offset] == app1Marker[0] &&
          _imgBytes[offset + 1] == app1Marker[1]) {
        // APP1セグメントの長さを取得 (2バイト)
        int segmentLength =
            (_imgBytes[offset + 2] << 8) | _imgBytes[offset + 3];
        // APP1セグメント前後を取得
        final beforeExif = _imgBytes.sublist(0, offset); // APP1セグメント前
        final afterExif =
            _imgBytes.sublist(offset + 2 + segmentLength); // APP1セグメント後
        // Exifデータがnullの場合はExifセグメントを削除したデータを返す。
        if (newExifBytes == null) {
          return Uint8List.fromList([...beforeExif, ...afterExif]);
        }
        // 新しいAPP1セグメントを生成 (APP1マーカー + セグメント長 + Exif識別子 + TIFFデータ)
        final newSegmentLength = newExifBytes.length + 2; // マーカーを含めるため+2
        final newSegment = [
          app1Marker[0],
          app1Marker[1],
          (newSegmentLength >> 8) & 0xFF, // 長さの上位バイト
          newSegmentLength & 0xFF, // 長さの下位バイト
          ...newExifBytes,
        ];
        // 新しいJPEGバイトデータを結合して返却する。
        return Uint8List.fromList([
          ...beforeExif,
          ...newSegment,
          ...afterExif,
        ]);
      }
      // 次のセグメントへ移動
      int segmentLength = (_imgBytes[offset + 2] << 8) | _imgBytes[offset + 3];
      offset += 2 + segmentLength; // マーカー + 長さ分をスキップ
    }
    // APP1セグメントが見つからなかった場合の処理
    if (newExifBytes == null) {
      // Exifを削除する場合はそのまま返却
      return _imgBytes;
    } else {
      // 新しいAPP1セグメントを生成
      final newSegmentLength = newExifBytes.length + 2; // マーカーを含めるため+2
      final newSegment = [
        app1Marker[0],
        app1Marker[1],
        (newSegmentLength >> 8) & 0xFF, // 長さの上位バイト
        newSegmentLength & 0xFF, // 長さの下位バイト
        ...newExifBytes,
      ];
      // SOIマーカー直後にExifセグメントを挿入したファイルを返す。
      return Uint8List.fromList([
        ..._imgBytes.sublist(0, 2), // SOIマーカー
        ...newSegment,
        ..._imgBytes.sublist(2), // 残りのデータ
      ]);
    }
  }
}
