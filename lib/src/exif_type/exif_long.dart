import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

class ExifLong extends ExifType {
  final int value;

  /// * [value] : The long type number.
  /// If a number outside this range is entered, an exception will be thrown.
  ExifLong(this.value) : super(EnumExifType.long) {
    if (value < 0 || value > 4294967295) {
      throw ArgumentError("Value $value is out of range for LONG type.");
    }
  }

  @override
  String toString() => value.toString();
}
