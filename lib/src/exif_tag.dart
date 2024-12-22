import 'package:simple_exif/src/exif_type/exif_ascii_code_array.dart';

import '../simple_exif.dart';

/// (en) This is a data class for handling Exif tag information.
/// By using this class, you can safely handle commonly used default tags.
///
/// (ja) これは、Exif のタグ情報を取り扱うためのデータクラスです。
/// このクラスを介することで、よく使われるデフォルトタグを安全に取り扱えます。
class ExifTag {
  final String name;
  final ExifType value;

  /// * [name] : ExifTag name.
  /// * [value] : The value.
  ExifTag._(this.name, this.value);

  /// * [value] : The image description.
  factory ExifTag.imageDescription(ExifAsciiCodeArray value) {
    return ExifTag._('ImageDescription', value);
  }

  /// * [value] : Manufacturer name.
  factory ExifTag.make(ExifAsciiCodeArray value) {
    return ExifTag._('Make', value);
  }

  /// * [value] : Camera model name.
  factory ExifTag.model(ExifAsciiCodeArray value) {
    return ExifTag._('Model', value);
  }

  // TODO 以降は調整中。

  /// * [value] : Image orientation.
  /// The value is an integer from 1 to 8, as follows:
  /// 1: No rotation.
  /// 2: Flip horizontally.
  /// 3: Rotate 180 degrees.
  /// 4: Flip vertically.
  /// 5: Rotate 90 degrees counterclockwise and flip horizontally.
  /// 6: Rotate 90 degrees counterclockwise.
  /// 7: Rotate 90 degrees clockwise and flip horizontally.
  /// 8: Rotate 90 degrees clockwise.
  factory ExifTag.orientation(ExifShort value) {
    return ExifTag._('Orientation', value);
  }

  /// The date and time the file was last modified.
  /// * [value] : It will automatically convert it into a string
  /// in the required format (YYYY:MM:DD HH:MM:SS).
  factory ExifTag.dateTime(DateTime value) {
    final formatted = value.toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')[0]
        .replaceAll('-', ':');
    return ExifTag._('DateTime', formatted);
  }

  /// The date and time the photo was taken.
  /// * [value] : It will automatically convert it into a string
  /// in the required format (YYYY:MM:DD HH:MM:SS).
  factory ExifTag.dateTimeOriginal(DateTime value) {
    final formatted = value.toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')[0]
        .replaceAll('-', ':');
    return ExifTag._('DateTimeOriginal', formatted);
  }

  /// * [value] : Software used for editing.
  factory ExifTag.software(String value) {
    return ExifTag._('Software', value);
  }

  /// * [value] : Exif version number represented as 4-byte fixed-length data
  /// (e.g. 0232 (Exif 2.32)).
  factory ExifTag.exifVersion(String value) {
    return ExifTag._('ExifVersion', value);
  }



  /// * [value] : Exposure time.
  factory ExifTag.exposureTime(ExifRational value) {
    return ExifTag._('ExposureTime', value);
  }

  /// * [value] : Aperture (f-number).
  factory ExifTag.fNumber(ExifRational value) {
    return ExifTag._('FNumber', value);
  }

  /// * [value] : ISO sensitivity.
  factory ExifTag.iso(int value) {
    return ExifTag._('ISO', value);
  }

  /// * [value] : Focal length.
  factory ExifTag.focalLength(ExifRational value) {
    return ExifTag._('FocalLength', value);
  }

  /// * [value] : Flash status.
  factory ExifTag.flash(int value) {
    return ExifTag._('Flash', value);
  }

  /// * [value] : Metering mode.
  factory ExifTag.meteringMode(int value) {
    return ExifTag._('MeteringMode', value);
  }

  /// * [value] : White balance mode.
  factory ExifTag.whiteBalance(int value) {
    return ExifTag._('WhiteBalance', value);
  }

  /// * [value] : Exposure program.
  factory ExifTag.exposureProgram(int value) {
    return ExifTag._('ExposureProgram', value);
  }

  /// * [value] : GPS latitude.
  factory ExifTag.gpsLatitude(double value) {
    return ExifTag._('GPSLatitude', value);
  }

  /// * [value] : GPS longitude.
  factory ExifTag.gpsLongitude(double value) {
    return ExifTag._('GPSLongitude', value);
  }

  /// * [value] : GPS altitude.
  factory ExifTag.gpsAltitude(double value) {
    return ExifTag._('GPSAltitude', value);
  }

  /// * [value] : GPS timestamp.
  factory ExifTag.gpsTimeStamp(String value) {
    return ExifTag._('GPSTimeStamp', value);
  }

  /// * [value] : GPS date stamp.
  factory ExifTag.gpsDateStamp(String value) {
    return ExifTag._('GPSDateStamp', value);
  }

  /// * [value] : Resolution unit.
  factory ExifTag.resolutionUnit(int value) {
    return ExifTag._('ResolutionUnit', value);
  }

  /// * [value] : X resolution.
  factory ExifTag.xResolution(ExifRational value) {
    return ExifTag._('XResolution', value);
  }

  /// * [value] : Y resolution.
  factory ExifTag.yResolution(ExifRational value) {
    return ExifTag._('YResolution', value);
  }

  /// * [value] : Color space.
  factory ExifTag.colorSpace(int value) {
    return ExifTag._('ColorSpace', value);
  }

  /// Create other tag.
  /// * [tagName] : Exif tag name.
  /// * [value] : Please note that the format is fixed for each tag name.
  /// Normally, you should use other constructors.
  /// I recommend using this constructor only for undefined constructors.
  factory ExifTag.custom(String tagName, dynamic value) {
    return ExifTag._(tagName, value);
  }
}
