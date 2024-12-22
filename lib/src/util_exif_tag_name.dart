class UtilExifTagName{

  /// TODO
  /// (en) Converts an Exif tag number into a tag name and returns it.
  /// If conversion is not possible, returns null.
  ///
  /// (ja) Exifタグ番号をタグ名に変換して返します。
  /// 変換できない場合はnullを返します。
  ///
  /// * [hexStr] : Exif tag number in hexadecimal.
  static String? convertFromHexStr(String hexStr){
    return _hexStrToName[hexStr];
  }

  /// (en) Returns the Exif tag name converted to a hexadecimal tag number.
  /// If conversion is not possible, returns null.
  ///
  /// (ja) Exifタグ名を16進数のタグ番号に変換して返します。
  /// 変換できない場合はnullを返します。
  ///
  /// * [tagName] : Exif tag name.
  static String? convertToHexStr(String tagName){
    return _nameToHexStr[tagName];
  }

  // TODO 作成中。
  static const Map<String, String> _hexStrToName = {

  };

  static const Map<String, String> _nameToHexStr = {

  };

}