import 'package:flutter/foundation.dart';

import 'exif_tag.dart';

/// (en) This is an inner class that analyzes, stores and
/// manipulates the entire Exif data.
/// This class may only be called from within this package.
///
/// (ja) これは、Exif データ全体を分析、保存、操作する内部クラスです。
/// このクラスは、このパッケージ内からのみ呼び出されます。
class ExifHandler {
  final Map<String, dynamic> _exifData = {};

  /// Exifセグメントを解析して_mapExifDataに格納します。
  ExifHandler.fromBytes(Uint8List bytes) {

  }

  /// (en) Returns true if the specified tag exists.
  ///
  /// (ja) 指定したタグが存在するならtrueを返します。
  ///
  /// * [tag] : The target tag.
  bool containsOf(String tag) {
    return _exifData.containsKey(tag);
  }

  /// (en) Gets a list of all tags.
  ///
  /// (ja) 全てのタグをリストで取得します。
  List<String> getAllTags() {
    return _exifData.keys.toList();
  }

  /// (en) Returns the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を返します。
  ///
  /// * [tagName] : Target tag name.
  dynamic getTagValue(String tagName) {
    return _exifData[tagName];
  }

  /// (en) Rewrites the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を書き換えます。
  ///
  /// * [tag] : For type safety, pass overriding data in a dedicated class.
  void updateTag(ExifTag tag) {
    _exifData[tag.tagName] = tag.value;
  }

  /// (en) Remove the content of the specified tag.
  ///
  /// (ja) 指定したタグの内容を削除します。
  ///
  /// * [tagName] : The tag name.
  void removeTag(String tagName){
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
    if(_exifData.isEmpty){
      return null;
    }
    else{
      // TODO
    }
  }
}
