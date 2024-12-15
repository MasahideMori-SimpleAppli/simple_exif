import 'package:flutter/foundation.dart';

import 'exif_handler.dart';

/// (en) A class for reading Exif data from an image.
///
/// (ja) 画像からExifデータを読み取るためのクラスです。
class ExifReader {
  final ExifHandler _handler;

  ExifReader(Uint8List bytes) : _handler = ExifHandler.fromBytes(bytes);

  /// (en) Gets a list of all tags.
  ///
  /// (ja) 全てのタグをリストで取得します。
  List<String> getAllTags() {
    return _handler.getAllTags();
  }

  /// (en) Returns true if the specified tag exists.
  ///
  /// (ja) 指定したタグが存在するならtrueを返します。
  ///
  /// * [tag] : The target tag.
  bool containsOf(String tag) {
    return _handler.containsOf(tag);
  }

  /// (en) Returns the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を返します。
  ///
  /// * [tag] : The target tag.
  dynamic getTagValue(String tag) {
    return _handler.getTagValue(tag);
  }
}
