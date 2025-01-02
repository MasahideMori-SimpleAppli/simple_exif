class UtilExifTagName {

  /// (en) Converts an Exif tag number into a tag name and returns it.
  /// If conversion is not possible, returns null.
  ///
  /// (ja) Exifタグ番号をタグ名に変換して返します。
  /// 変換できない場合はnullを返します。
  ///
  /// * [hexStr] : Exif tag number in hexadecimal.
  static String? convertFromHexStr(String hexStr) {
    return _hexStrToName[hexStr];
  }

  /// (en) Returns the Exif tag name converted to a hexadecimal tag number.
  /// If conversion is not possible, returns null.
  ///
  /// (ja) Exifタグ名を16進数のタグ番号に変換して返します。
  /// 変換できない場合はnullを返します。
  ///
  /// * [tagName] : Exif tag name.
  static String? convertToHexStr(String tagName) {
    return _nameToHexStr[tagName];
  }

  static const Map<String, String> _nameToHexStr = {
    // Tiff Rev 6.0　//
    // 画像データの構成に関するタグ
    "Orientation": "112",
    "YCbCrPositioning" : "213",
    "XResolution" : "11A",
    "YResolution" : "11B",
    "ResolutionUnit" : "128",
    // その他のタグ
    "DateTime" : "132",
    "ImageDescription" : "10E",
    "Make" : "10F",
    "Model" : "110",
    "Software" : "131",
    "Artist" : "13B",
    "Copyright" : "8298",
    // Exif IFD (2.3) //
    // バージョンに関するタグ
    "ExifVersion" : "9000",
    "FlashpixVersion" : "A000",
    // 画像データの特性に関するタグ
    "ColorSpace" : "A001",
    // 構造に関するタグ
    "ComponentsConfiguration" : "9101",
    "PixelXDimension" : "A002",
    "PixelYDimension" : "A003",
    // 日時に関するタグ
    "DateTimeOriginal" : "9003",
    // 撮影条件に関するタグ
    "ExposureTime" : "829A",
    "FNumber" : "829D",
    "Flash" : "9209",
    "FocalLength" : "920A",
    "ExposureMode" : "A402",
    "WhiteBalance" : "A403",
    "SceneCaptureType" : "A406",
    // GPS //
    "GPSVersionID" : "0",
    "GPSLatitudeRef" : "1",
    "GPSLatitude" : "2",
    "GPSLongitudeRef" : "3",
    "GPSLongitude" : "4",
    "GPSAltitudeRef" : "5",
    "GPSAltitude" : "6",
    "GPSTimeStamp" : "7",
    "GPSDateStamp" : "1D"
  };

  static final Map<String, String> _hexStrToName = {
    for (var entry in _nameToHexStr.entries) entry.value: entry.key
  };
}
