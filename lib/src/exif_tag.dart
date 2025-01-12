import '../simple_exif.dart';

/// (en) This is a data class for handling Exif tag information.
/// By using this class, you can safely handle commonly used default tags.
///
/// (ja) これは、Exif のタグ情報を取り扱うためのデータクラスです。
/// このクラスを介することで、よく使われるデフォルトタグを安全に取り扱えます。
class ExifTag {
  final int id;
  final ExifDataType value;
  final EnumIFDType ifdType;

  /// * [id] : Exif tag id.
  /// * [value] : Dedicated data type.
  /// If the data count is 1, use ExifShort, etc.
  /// If it is 2 or more, use ExifShortArray, etc.
  /// * [ifdType] : Defines the type of IFD each tag belongs to.
  ExifTag._(this.id, this.value, this.ifdType);

  // Tiff Rev 6.0　//

  // 画像データの構成に関するタグ

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
    return ExifTag._(274, value, EnumIFDType.tiff);
  }

  /// * [value] : The placement of chroma samples relative to luma samples.
  ///
  /// 1 : Center. (Default, YCbCr 4:2:0).
  ///
  /// 2 : Co-sited. (YCbCr 4:2:2).
  ///
  /// other : Reservation.
  factory ExifTag.yCbCrPositioning(ExifShort value) {
    return ExifTag._(531, value, EnumIFDType.tiff);
  }

  /// * [value] : The Image X resolution.
  /// Default is 72 (dpi) (ResolutionUnit = 2).
  /// If the resolution is unknown, it must be recorded as 72 dpi.
  factory ExifTag.xResolution(ExifRational value) {
    return ExifTag._(282, value, EnumIFDType.tiff);
  }

  /// * [value] : The Image Y resolution.
  /// The same value as XResolution must be recorded.
  factory ExifTag.yResolution(ExifRational value) {
    return ExifTag._(283, value, EnumIFDType.tiff);
  }

  /// * [value] : Resolution unit.
  /// 2 : inch. (Default, should be 2 if unknown.)
  /// 3 : cm.
  /// other : Reservation.
  factory ExifTag.resolutionUnit(ExifShort value) {
    return ExifTag._(296, value, EnumIFDType.tiff);
  }

  // その他のタグ

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
      return ExifTag._(306, ExifAsciiCodeArray(formatted), EnumIFDType.tiff);
    } else {
      const String unknown = "    :  :     :  :  ";
      return ExifTag._(306, ExifAsciiCodeArray(unknown), EnumIFDType.tiff);
    }
  }

  /// * [value] : The image description (Image title).
  factory ExifTag.imageDescription(ExifAsciiCodeArray value) {
    return ExifTag._(270, value, EnumIFDType.tiff);
  }

  /// * [value] : Camera manufacturer name.
  factory ExifTag.make(ExifAsciiCodeArray value) {
    return ExifTag._(271, value, EnumIFDType.tiff);
  }

  /// * [value] : Camera model name or model number.
  factory ExifTag.model(ExifAsciiCodeArray value) {
    return ExifTag._(272, value, EnumIFDType.tiff);
  }

  /// * [value] : Software used for editing.
  factory ExifTag.software(ExifAsciiCodeArray value) {
    return ExifTag._(305, value, EnumIFDType.tiff);
  }

  /// * [value] : Camera owner's name.
  /// If not listed, it will be treated as unknown.
  factory ExifTag.artist(ExifAsciiCodeArray value) {
    return ExifTag._(315, value, EnumIFDType.tiff);
  }

  /// * [value] : The copyright.
  /// Used to indicate both the photographer and editor copyright holders.
  ///
  /// The specifications for writing it are as follows:
  ///
  /// e.g. 1. When listing both the photographer and editor
  ///
  /// Photographer + NULL [00.H] + Editor + NULL [00.H]
  ///
  /// e.g. 2.  When listing only the photographer
  ///
  /// Photographer + NULL [00.H]
  ///
  /// e.g. 3. When listing only the editor
  ///
  /// Space [20.H] + NULL [00.H] + Editor + NULL [00.H]
  ///
  /// In this library, the NULL code at the end is automatically inserted by
  /// the ExifAsciiCodeArray class,
  /// so please input only the delimiting NULL code as data.
  ///
  factory ExifTag.copyright(ExifAsciiCodeArray value) {
    return ExifTag._(33432, value, EnumIFDType.tiff);
  }

  // Exif IFD (2.3)//

  // バージョンに関するタグ

  /// * [value] : Exif version number represented as 4-byte fixed-length data
  /// (e.g. 0232 (Exif 2.32)).
  /// Normally, you should assign a value converted from
  /// ExifUndefined.fromASCIICodeArray(v).
  factory ExifTag.exifVersion(ExifUndefined value) {
    if (value.count() != 4) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(36864, value, EnumIFDType.exif);
  }

  /// * [value] : Indicates the version of the Flashpix format that
  /// the FPXR file supports.
  /// If the FPXR function is compatible with Flashpix format version 1.0,
  /// 4-byte ASCII "0100" is recorded. Other values are reserved.
  factory ExifTag.flashpixVersion(ExifUndefined value) {
    if (value.count() != 4) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(40960, value, EnumIFDType.exif);
  }

  // 画像データの特性に関するタグ

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
    return ExifTag._(40961, value, EnumIFDType.exif);
  }

  // 構造に関するタグ

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
    if (value.count() != 4) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(37121, value, EnumIFDType.exif);
  }

  /// * [value] : ExifShort or ExifLong type.
  /// Meaningful Image Width.
  factory ExifTag.pixelXDimension(ExifDataType value) {
    if (value.dataType != EnumExifDataType.short &&
        value.dataType != EnumExifDataType.long) {
      throw ArgumentError("Only ExifShort or ExifLong are available.");
    }
    return ExifTag._(40962, value, EnumIFDType.exif);
  }

  /// * [value] : ExifShort or ExifLong type.
  /// Meaningful Image Height.
  factory ExifTag.pixelYDimension(ExifDataType value) {
    if (value.dataType != EnumExifDataType.short &&
        value.dataType != EnumExifDataType.long) {
      throw ArgumentError("Only ExifShort or ExifLong are available.");
    }
    return ExifTag._(40963, value, EnumIFDType.exif);
  }

  // 日時に関するタグ

  /// The date and time the photo was taken.
  /// * [value] : It will automatically convert it into a string
  /// in the required format (YYYY:MM:DD HH:MM:SS).
  factory ExifTag.dateTimeOriginal(DateTime value) {
    final String formatted = value
        .toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')[0]
        .replaceAll('-', ':');
    return ExifTag._(36867, ExifAsciiCodeArray(formatted), EnumIFDType.exif);
  }

  // 撮影条件に関するタグ

  /// * [value] : Exposure time. The unit is seconds.
  factory ExifTag.exposureTime(ExifRational value) {
    return ExifTag._(33434, value, EnumIFDType.exif);
  }

  /// * [value] : Aperture (f-number).
  factory ExifTag.fNumber(ExifRational value) {
    return ExifTag._(33437, value, EnumIFDType.exif);
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
    return ExifTag._(37385, value, EnumIFDType.exif);
  }

  /// * [value] : This indicates the actual focal length of
  /// the photographic lens. The unit is mm.
  factory ExifTag.focalLength(ExifRational value) {
    return ExifTag._(37386, value, EnumIFDType.exif);
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
    return ExifTag._(41986, value, EnumIFDType.exif);
  }

  /// * [value] : Follow the code below:
  ///
  /// 0 : Automatic.
  ///
  /// 1 : Manual.
  ///
  /// other : Reservation.
  factory ExifTag.whiteBalance(ExifShort value) {
    return ExifTag._(41987, value, EnumIFDType.exif);
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
    return ExifTag._(41990, value, EnumIFDType.exif);
  }

  // GPS //

  /// * [value] : Indicates the version of GPSInfoIFD.
  /// If the GPSInfo tag is included, this tag must be included.
  /// The byte count must be 4.
  ///
  /// default : 2.3.0.0
  ///
  /// other : Reservation.
  factory ExifTag.gpsVersionID(ExifByteArray value) {
    if (value.count() != 4) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(0, value, EnumIFDType.gps);
  }

  /// * [value] : GPS latitude reference.
  ///
  /// Follow the code below:
  ///
  /// N : North latitude.
  ///
  /// S : South latitude.
  ///
  /// other : Reservation.
  factory ExifTag.gpsLatitudeRef(ExifAsciiCodeArray value) {
    return ExifTag._(1, value, EnumIFDType.gps);
  }

  /// * [value] : GPS latitude.
  /// eg. [dd/1, mm/1, ss/1] or [dd/1, mmmm/100, 0/1]
  factory ExifTag.gpsLatitude(ExifRationalArray value) {
    if (value.count() != 3) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(2, value, EnumIFDType.gps);
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
  factory ExifTag.gpsLongitudeRef(ExifAsciiCodeArray value) {
    return ExifTag._(3, value, EnumIFDType.gps);
  }

  /// * [value] : GPS longitude.
  /// eg. [ddd/1, mm/1, ss/1] or [ddd/1, mmmm/100, 0/1]
  factory ExifTag.gpsLongitude(ExifRationalArray value) {
    if (value.count() != 3) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(4, value, EnumIFDType.gps);
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
    return ExifTag._(5, value, EnumIFDType.gps);
  }

  /// * [value] : GPS altitude.
  /// The unit is meters.
  factory ExifTag.gpsAltitude(ExifRational value) {
    return ExifTag._(6, value, EnumIFDType.gps);
  }

  /// * [value] : GPS timestamp. This is UTC(Coordinated Universal Time).
  /// The format is [hour, min, sec].
  factory ExifTag.gpsTimeStamp(ExifRationalArray value) {
    if (value.count() != 3) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(7, value, EnumIFDType.gps);
  }

  /// * [value] : GPS date stamp.
  /// The format is YYYY:MM:DD.
  factory ExifTag.gpsDateStamp(ExifAsciiCodeArray value) {
    if (value.count() != 11) {
      throw ArgumentError("The data length is invalid.");
    }
    return ExifTag._(29, value, EnumIFDType.gps);
  }

  // custom tag //

  /// Create other tag.
  /// * [tagID] : Exif tag id.
  /// You can use the UtilExifTag class to get the ID from the name.
  /// * [value] : Exif tag value.
  /// * [ifdType] : The tag type.
  factory ExifTag.custom(int tagID, ExifDataType value, EnumIFDType ifdType) {
    return ExifTag._(tagID, value, ifdType);
  }

  /// Convert data to map format.
  Map<String, dynamic> toDict() {
    String? tagName = UtilExifTag.getTagNameFromID(id);
    return {
      "ClassName": "ExifTag",
      "TagID": id,
      "TagName": tagName ?? "Unsupported value",
      "TagValueType": value.dataType.name,
      "IFDType": ifdType.name,
      "TagValue": value.toString()
    };
  }

  @override
  String toString() => toDict().toString();
}
