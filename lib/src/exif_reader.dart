import 'dart:typed_data';
import 'package:simple_exif/simple_exif.dart';

import 'exif_handler.dart';

/// (en) A class for reading Exif data from an image.
///
/// (ja) 画像からExifデータを読み取るためのクラスです。
class ExifReader {
  final ExifHandler _handler;

  ExifReader(Uint8List bytes) : _handler = ExifHandler.fromBytes(bytes);

  /// (en) Gets a list of all tag names.
  ///
  /// (ja) 全てのタグをリストで取得します。
  List<String> getAllTagNames() {
    return _handler.getAllTagNames();
  }

  /// (en) Returns true if the specified tag exists.
  ///
  /// (ja) 指定したタグが存在するならtrueを返します。
  ///
  /// * [tagName] : The target tag name.
  bool containsOf(String tagName) {
    return _handler.containsOf(tagName);
  }

  /// (en) Returns the specified tag.
  ///
  /// (ja) 指定したタグを返します。
  ///
  /// * [tagName] : The target tag name.
  ExifTag? getTag(String tagName) {
    return _handler.getTag(tagName);
  }
}
