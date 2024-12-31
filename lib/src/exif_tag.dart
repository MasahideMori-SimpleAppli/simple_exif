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

  /// * [value] : The image description (Image title).
  factory ExifTag.imageDescription(ExifAsciiCodeArray value) {
    return ExifTag._('ImageDescription', value);
  }

  /// * [value] : Camera manufacturer name.
  factory ExifTag.make(ExifAsciiCodeArray value) {
    return ExifTag._('Make', value);
  }

  /// * [value] : Camera model name or model number.
  factory ExifTag.model(ExifAsciiCodeArray value) {
    return ExifTag._('Model', value);
  }

  /// * [value] : Image orientation.
  /// The value is an integer from 1 to 8, as follows:
  ///
  /// 1: No rotation.
  ///
  /// The 0th row of the image array is at the top of the image when
  /// viewed by the eye, and the 0th column is to the left of the image.
  ///
  /// 2: Flip horizontally.
  ///
  /// The 0th row of the image array is at the top of the image when
  /// viewed by the eye, and the 0th column is to the right of the image.
  ///
  /// 3: Rotate 180 degrees.
  ///
  /// The 0th row of the image array is at the bottom of the image when
  /// viewed by the eye, and the 0th column is to the right of the image.
  ///
  /// 4: Flip vertically.
  ///
  /// The 0th row of the image array is at the bottom of the image when
  /// viewed by the eye, and the 0th column is to the left of the image.
  ///
  /// 5: Rotate 90 degrees counterclockwise and flip horizontally.
  ///
  /// The 0th row of the image array is to the left of the image when
  /// viewed by the eye, and the 0th column is to the top of the image.
  ///
  /// 6: Rotate 90 degrees counterclockwise.
  ///
  /// The 0th row of the image array is to the right of the image when
  /// viewed by the eye, and the 0th column is to the top of the image.
  ///
  /// 7: Rotate 90 degrees clockwise and flip horizontally.
  ///
  /// The 0th row of the image array is to the right of the image when
  /// viewed by the eye, and the 0th column is to the bottom of the image.
  ///
  /// 8: Rotate 90 degrees clockwise.
  ///
  /// The 0th row of the image array is to the left of the image when
  /// viewed by the eye, and the 0th column is to the bottom of the image.
  ///
  factory ExifTag.orientation(ExifShort value) {
    return ExifTag._('Orientation', value);
  }

  /// * [value] : The Image X resolution.
  /// Default is 72 dpi (ResolutionUnit = 2).
  /// If the resolution is unknown, it must be recorded as 72 dpi.
  factory ExifTag.xResolution(ExifRational value) {
    return ExifTag._('XResolution', value);
  }

  /// * [value] : The Image Y resolution.
  /// The same value as XResolution must be recorded.
  factory ExifTag.yResolution(ExifRational value) {
    return ExifTag._('YResolution', value);
  }

  /// * [value] : Resolution unit.
  /// 2 : inch. (Default, should be 2 if unknown.)
  /// 3 : cm.
  /// other : reservation.
  factory ExifTag.resolutionUnit(ExifShort value) {
    return ExifTag._('ResolutionUnit', value);
  }

  /// * [value] : Software used for editing.
  factory ExifTag.software(ExifAsciiCodeArray value) {
    return ExifTag._('Software', value);
  }

  /// The date and time the file was last modified.
  /// * [value] : It will automatically convert it into a string
  /// in the required format (YYYY:MM:DD HH:MM:SS).
  /// If the value is unknown, assigning null will automatically convert
  /// it to a special representation.
  factory ExifTag.dateTime(DateTime? value) {
    if (value != null) {
      final String formatted = value
          .toIso8601String()
          .replaceFirst('T', ' ')
          .split('.')[0]
          .replaceAll('-', ':');
      return ExifTag._('DateTime', ExifAsciiCodeArray.fromStr(formatted));
    } else {
      const String unknown = "    :  :     :  :  ";
      return ExifTag._('name', ExifAsciiCodeArray.fromStr(unknown));
    }
  }

  /// * [value] : Camera owner's name.
  /// If not listed, it will be treated as unknown.
  factory ExifTag.artist(ExifAsciiCodeArray value) {
    return ExifTag._('Artist', value);
  }

  /// * [value] : The placement of chroma samples relative to luma samples.
  /// 1 : Center. (Default, YCbCr 4:2:0)
  /// 2 : Co-sited. (YCbCr 4:2:2)
  /// other : reservation.
  factory ExifTag.yCbCrPositioning(ExifShort value) {
    return ExifTag._('YCbCrPositioning', value);
  }

  /// * [value] : Exposure time. The unit is seconds.
  factory ExifTag.exposureTime(ExifRational value) {
    return ExifTag._('ExposureTime', value);
  }

  // TODO 以降は調整中。

  /// The date and time the photo was taken.
  /// * [value] : It will automatically convert it into a string
  /// in the required format (YYYY:MM:DD HH:MM:SS).
  factory ExifTag.dateTimeOriginal(DateTime value) {
    final formatted = value
        .toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')[0]
        .replaceAll('-', ':');
    return ExifTag._('DateTimeOriginal', formatted);
  }

  /// * [value] : Exif version number represented as 4-byte fixed-length data
  /// (e.g. 0232 (Exif 2.32)).
  factory ExifTag.exifVersion(String value) {
    return ExifTag._('ExifVersion', value);
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
