/// (en) A utility for converting between Exif TagID and TagName.
/// Currently supports Exif 2.3.
///
/// (ja) ExifのTagIDとTagNameを相互に変換するためのユーティリティ。
/// 現在、Exif 2.3に対応しています。
class UtilExifTag {
  /// * [id] : Exif tag id.
  /// TIFF6.0, Exif2.3 and GPS tag IDs are supported.
  /// If any other tag ID is specified, null is returned.
  static String? getTagNameFromID(int id) {
    if (_reversedTagNameToIDofTIFF6_0.containsKey(id)) {
      return _reversedTagNameToIDofTIFF6_0[id];
    }
    if (_reversedTagNameToIDofExif2_3.containsKey(id)) {
      return _reversedTagNameToIDofExif2_3[id];
    }
    if (_reversedTagNameToIDofGPS.containsKey(id)) {
      return _reversedTagNameToIDofGPS[id];
    }
    return null;
  }

  // key : tag name.
  // value : tag id (dec).
  static Map<String, int> _tagNameToIDofTIFF6_0 = {
    "ImageWidth": 256,
    "ImageLength": 257,
    "BitsPerSample": 258,
    "Compression": 259,
    "PhotometricInterpretation": 262,
    "Orientation": 274,
    "SamplesPerPixel": 277,
    "PlanarConfiguration": 284,
    "YCbCrSubSampling": 530,
    "YCbCrPositioning": 531,
    "XResolution": 282,
    "YResolution": 283,
    "ResolutionUnit": 296,
    "StripOffsets": 273,
    "RowsPerStrip": 278,
    "StripByteCounts": 279,
    "JPEGInterchangeFormat": 513,
    "JPEGInterchangeFormatLength": 514,
    "TransferFunction": 301,
    "WhitePoint": 318,
    "PrimaryChromaticities": 319,
    "YCbCrCoefficients": 529,
    "ReferenceBlackWhite": 532,
    "DateTime": 306,
    "ImageDescription": 270,
    "Make": 271,
    "Model": 272,
    "Software": 305,
    "Artist": 315,
    "Copyright": 33432
  };

  // key : tag id (dec).
  // value : tag name.
  static Map<int, String> _reversedTagNameToIDofTIFF6_0 = {
    for (var entry in _tagNameToIDofTIFF6_0.entries) entry.value: entry.key
  };

  // key : tag name.
  // value : tag id (dec).
  static Map<String, int> _tagNameToIDofExif2_3 = {
    "ExifVersion": 36864,
    "FlashpixVersion": 40960,
    "ColorSpace": 40961,
    "Gamma": 42240,
    "ComponentsConfiguration": 37121,
    "CompressedBitsPerPixel": 37122,
    "PixelXDimension": 40962,
    "PixelYDimension": 40963,
    "MakerNote": 37500,
    "UserComment": 37510,
    "RelatedSoundFile": 40964,
    "DateTimeOriginal": 36867,
    "DateTimeDigitized": 36868,
    "SubSecTime": 37520,
    "SubSecTimeOriginal": 37521,
    "SubSecTimeDigitized": 37522,
    "ImageUniqueID": 42016,
    "CameraOwnerName": 42032,
    "BodySerialNumber": 42033,
    "LensSpecification": 42034,
    "LensMake": 42035,
    "LensModel": 42036,
    "LensSerialNumber": 42037,
    "ExposureTime": 33434,
    "FNumber": 33437,
    "ExposureProgram": 34850,
    "SpectralSensitivity": 34852,
    "PhotographicSensitivity": 34855,
    "OECF": 34856,
    "SensitivityType": 34864,
    "StandardOutputSensitivity": 34865,
    "RecommendedExposureIndex": 34866,
    "ISOSpeed": 34867,
    "ISOSpeedLatitudeyyy": 34868,
    "ISOSpeedLatitudezzz": 34869,
    "ShutterSpeedValue": 37377,
    "ApertureValue": 37378,
    "BrightnessValue": 37379,
    "ExposureBiasValue": 37380,
    "MaxApertureValue": 37381,
    "SubjectDistance": 37382,
    "MeteringMode": 37383,
    "LightSource": 37384,
    "Flash": 37385,
    "FocalLength": 37386,
    "SubjectArea": 37396,
    "FlashEnergy": 41483,
    "SpatialFrequencyResponse": 41484,
    "FocalPlaneXResolution": 41486,
    "FocalPlaneYResolution": 41487,
    "FocalPlaneResolutionUnit": 41488,
    "SubjectLocation": 41492,
    "ExposureIndex": 41493,
    "SensingMethod": 41495,
    "FileSource": 41728,
    "SceneType": 41729,
    "CFAPattern": 41730,
    "CustomRendered": 41985,
    "ExposureMode": 41986,
    "WhiteBalance": 41987,
    "DigitalZoomRatio": 41988,
    "FocalLengthIn35mmFilm": 41989,
    "SceneCaptureType": 41990,
    "GainControl": 41991,
    "Contrast": 41992,
    "Saturation": 41993,
    "Sharpness": 41994,
    "DeviceSettingDescription": 41995,
    "SubjectDistanceRange": 41996
  };

  // key : tag id (dec).
  // value : tag name.
  static Map<int, String> _reversedTagNameToIDofExif2_3 = {
    for (var entry in _tagNameToIDofExif2_3.entries) entry.value: entry.key
  };

  // key : tag name.
  // value : tag id (dec).
  static Map<String, int> _tagNameToIDofGPS = {
    'GPSVersionID': 0,
    'GPSLatitudeRef': 1,
    'GPSLatitude': 2,
    'GPSLongitudeRef': 3,
    'GPSLongitude': 4,
    'GPSAltitudeRef': 5,
    'GPSAltitude': 6,
    'GPSTimeStamp': 7,
    'GPSSatellites': 8,
    'GPSStatus': 9,
    'GPSMeasureMode': 10,
    'GPSDOP': 11,
    'GPSSpeedRef': 12,
    'GPSSpeed': 13,
    'GPSTrackRef': 14,
    'GPSTrack': 15,
    'GPSImgDirectionRef': 16,
    'GPSImgDirection': 17,
    'GPSMapDatum': 18,
    'GPSDestLatitudeRef': 19,
    'GPSDestLatitude': 20,
    'GPSDestLongitudeRef': 21,
    'GPSDestLongitude': 22,
    'GPSDestBearingRef': 23,
    'GPSDestBearing': 24,
    'GPSDestDistanceRef': 25,
    'GPSDestDistance': 26,
    'GPSProcessingMethod': 27,
    'GPSAreaInformation': 28,
    'GPSDateStamp': 29,
    'GPSDifferential': 30,
    'GPSHPositioningError': 31,
  };

  // key : tag id (dec).
  // value : tag name.
  static Map<int, String> _reversedTagNameToIDofGPS = {
    for (var entry in _tagNameToIDofGPS.entries) entry.value: entry.key
  };
}
