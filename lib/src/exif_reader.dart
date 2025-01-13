import 'dart:typed_data';
import '../../simple_exif.dart';

import 'exif_handler.dart';

/// (en) A class for reading Exif data from an image.
///
/// (ja) 画像からExifデータを読み取るためのクラスです。
class ExifReader {
  final ExifHandler _handler;

  ExifReader(Uint8List bytes) : _handler = ExifHandler.fromBytes(bytes);

  /// (en) Gets a list of all tag IDs.
  ///
  /// (ja) 全てのタグIDをリストで取得します。
  List<int> getAllTagIDs() {
    return _handler.getAllTagIDs();
  }

  /// (en) Gets a copy of all tags in a list.
  ///
  /// (ja) 全てのタグのコピーをリストで取得します。
  List<ExifTag> getCopiedAllTags() {
    List<ExifTag> r = [];
    List<int> allIDs = getAllTagIDs();
    for (int i in allIDs) {
      r.add(_handler.getTag(i)!.deepCopy());
    }
    return r;
  }

  /// (en) Returns true if the specified tag exists.
  ///
  /// (ja) 指定したタグが存在するならtrueを返します。
  ///
  /// * [tagID] : The target tag id.
  bool containsOf(int tagID) {
    return _handler.containsOf(tagID);
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
    return _handler.getTag(tagID);
  }
}
