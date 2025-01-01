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

  // Tiff Rev 6.0//

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
  /// Default is 72 (dpi) (ResolutionUnit = 2).
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
  /// other : Reservation.
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
  ///
  /// 1 : Center. (Default, YCbCr 4:2:0).
  ///
  /// 2 : Co-sited. (YCbCr 4:2:2).
  ///
  /// other : Reservation.
  factory ExifTag.yCbCrPositioning(ExifShort value) {
    return ExifTag._('YCbCrPositioning', value);
  }

  // Exif 2.3 //

  /// * [value] : Exposure time. The unit is seconds.
  factory ExifTag.exposureTime(ExifRational value) {
    return ExifTag._('ExposureTime', value);
  }

  /// * [value] : Aperture (f-number).
  factory ExifTag.fNumber(ExifRational value) {
    return ExifTag._('FNumber', value);
  }

  /// * [value] : Exif version number represented as 4-byte fixed-length data
  /// (e.g. 0232 (Exif 2.32)).
  /// Normally, you should assign a value converted from
  /// ExifUndefined.fromASCIICodeArray(v).
  factory ExifTag.exifVersion(ExifUndefined value) {
    if(value.count() != 4){
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._('ExifVersion', value);
  }

  /// The date and time the photo was taken.
  /// * [value] : It will automatically convert it into a string
  /// in the required format (YYYY:MM:DD HH:MM:SS).
  factory ExifTag.dateTimeOriginal(DateTime value) {
    final String formatted = value
        .toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')[0]
        .replaceAll('-', ':');
    return ExifTag._('DateTimeOriginal', ExifAsciiCodeArray.fromStr(formatted));
  }

  /// * [value] : The 4-byte ASCII code value.
  ///
  /// default : 4560 (RGB uncompressed)
  ///
  /// other : 1230 (Other)
  ///
  /// The meaning of each code number is as follows:
  ///
  /// 0 : Does not exist.
  ///
  /// 1 : Y.
  ///
  /// 2 : Cb.
  ///
  /// 3 : Cr.
  ///
  /// 4 : R.
  ///
  /// 5 : G.
  ///
  /// 6 : B.
  ///
  /// other : Reservation.
  factory ExifTag.componentsConfiguration(ExifUndefined value) {
    if(value.count() != 4){
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._('ComponentsConfiguration', value);
  }

  /// * [value] : Flash status.
  ///
  /// First, consider the bit sequence as follows:
  /// [[MSB 7 6 5 4-3 2-1 0 LSB]].
  ///
  /// The following bitwise flash flags are displayed:
  ///
  /// 0 : 0b = No flash, 1b = Flash.
  ///
  /// 2-1 : 00b = No strobe return detection, 01b = reservation,
  /// 10b = Strobe return not detected, 11b = Strobe return detection.
  ///
  /// 4-3 : Camera flash mode value. 00b = Unknown, 01b = Forced flash mode,
  /// 10b = Forced non-lighting mode, 11b = Auto flash mode.
  ///
  /// 5 : 0b = Has strobe function. 1b = No strobe function.
  ///
  /// 6 : 0b = No red-eye reduction or unknown. 1b = With red-eye reduction.
  ///
  factory ExifTag.flash(ExifShort value) {
    return ExifTag._('Flash', value);
  }

  /// * [value] : This indicates the actual focal length of
  /// the photographic lens. The unit is mm.
  factory ExifTag.focalLength(ExifRational value) {
    return ExifTag._('FocalLength', value);
  }

  /// * [value] : Indicates the version of the Flashpix format that
  /// the FPXR file supports.
  /// If the FPXR function is compatible with Flashpix format version 1.0,
  /// 4-byte ASCII "0100" is recorded. Other values are reserved.
  factory ExifTag.flashpixVersion(ExifUndefined value){
    if(value.count() != 4){
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._('FlashpixVersion', value);
  }

  /// * [value] : Color space.
  ///
  /// Follow the code below:
  ///
  /// 1 : sRGB.
  ///
  /// 0xFFFF : Uncalibrated.
  ///
  /// other : Reservation.
  factory ExifTag.colorSpace(ExifShort value) {
    return ExifTag._('ColorSpace', value);
  }

  /// * [value] : ExifShort or ExifLong type.
  /// Meaningful Image Width.
  factory ExifTag.pixelXDimension(ExifType value) {
    if(value.dataType != EnumExifType.short && value.dataType != EnumExifType.long){
      throw ArgumentError("Only ExifShort or ExifLong are available.");
    }
    return ExifTag._('PixelXDimension', value);
  }


  /// * [value] : ExifShort or ExifLong type.
  /// Meaningful Image Height.
  factory ExifTag.pixelYDimension(ExifType value) {
    if(value.dataType != EnumExifType.short && value.dataType != EnumExifType.long){
      throw ArgumentError("Only ExifShort or ExifLong are available.");
    }
    return ExifTag._('PixelYDimension', value);
  }

  /// * [value] : Follow the code below:
  ///
  /// 0 : Automatic Exposure.
  ///
  /// 1 : Exposure Manual.
  ///
  /// 2 : Auto Bracketing. (A mode for taking continuous shots while
  /// changing exposure settings under specified conditions.)
  ///
  /// other : Reservation.
  factory ExifTag.exposureMode(ExifShort value) {
    return ExifTag._('ExposureMode', value);
  }

  /// * [value] : Follow the code below:
  ///
  /// 0 : Automatic.
  ///
  /// 1 : Manual.
  ///
  /// other : Reservation.
  factory ExifTag.whiteBalance(ExifShort value) {
    return ExifTag._('WhiteBalance', value);
  }

  /// * [value] : Follow the code below:
  ///
  /// 0 : Default.
  ///
  /// 1 : Landscape.
  ///
  /// 2 : People.
  ///
  /// 3 : Night view.
  ///
  /// other : Reservation.
  factory ExifTag.sceneCaptureType(ExifShort value) {
    return ExifTag._('SceneCaptureType', value);
  }

  // GPS //

  /// * [value] : GPS latitude reference.
  ///
  /// Follow the code below:
  ///
  /// N : North latitude.
  ///
  /// S : South latitude.
  ///
  /// other : Reservation.
  factory ExifTag.gpsLatitudeRef(ExifAsciiCode value) {
    return ExifTag._('GPSLatitudeRef', value);
  }

  /// * [value] : GPS latitude.
  /// eg. [dd/1, mm/1, ss/1] or [dd/1, mmmm/100, 0/1]
  factory ExifTag.gpsLatitude(ExifRationalArray value) {
    if(value.count() != 3){
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._('GPSLatitude', value);
  }

  /// * [value] : GPS longitude reference.
  ///
  /// Follow the code below:
  ///
  /// E : East longitude.
  ///
  /// W : West longitude.
  ///
  /// other : Reservation.
  factory ExifTag.gpsLongitudeRef(ExifAsciiCode value) {
    return ExifTag._('GPSLongitudeRef', value);
  }

  /// * [value] : GPS longitude.
  /// eg. [ddd/1, mm/1, ss/1] or [ddd/1, mmmm/100, 0/1]
  factory ExifTag.gpsLongitude(ExifRationalArray value) {
    if(value.count() != 3){
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._('GPSLongitude', value);
  }

  /// * [value] : GPS altitude reference
  ///
  /// Follow the code below:
  ///
  /// 0 : When the reference point is sea level and the altitude is
  /// higher than sea level.
  ///
  /// 1 : If the altitude is lower than sea level.
  /// (The GPSAltitude tag contains the absolute altitude value.).
  ///
  /// other : Reservation.
  factory ExifTag.gpsAltitudeRef(ExifByte value) {
    return ExifTag._('GPSAltitudeRef', value);
  }

  /// * [value] : GPS altitude.
  /// The unit is meters.
  factory ExifTag.gpsAltitude(ExifRational value) {
    return ExifTag._('GPSAltitude', value);
  }

  /// * [value] : GPS timestamp. This is UTC(Coordinated Universal Time).
  /// The format is [hour, min, sec].
  factory ExifTag.gpsTimeStamp(ExifRationalArray value) {
    if(value.count() != 3){
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._('GPSTimeStamp', value);
  }

  /// * [value] : GPS date stamp.
  /// The format is YYYY:MM:DD.
  factory ExifTag.gpsDateStamp(ExifAsciiCodeArray value) {
    if(value.count() != 11){
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._('GPSDateStamp', value);
  }

  // custom tag //

  /// Create other tag.
  /// * [tagName] : Exif tag name.
  /// * [value] : Please note that the format is fixed for each tag name.
  /// Normally, you should use other constructors.
  /// I recommend using this constructor only for undefined constructors.
  factory ExifTag.custom(String tagName, dynamic value) {
    return ExifTag._(tagName, value);
  }
}
