import 'dart:typed_data';

import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_long.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

class ExifRational extends ExifType{
  final ExifLong numerator;
  final ExifLong denominator;

  /// * [numerator] : x of x/y.　4 bytes (32-bit unsigned integer).
  /// * [denominator] : y of x/y. 4 bytes (32-bit unsigned integer).
  ExifRational(this.numerator, this.denominator) : super(EnumExifType.rational){
    if (denominator.value == 0) {
      throw ArgumentError("Denominator cannot be zero.");
    }
  }

  double toDouble() {
    if (denominator.value == 0) {
      throw ArgumentError("Denominator cannot be zero.");
    }
    return numerator.value / denominator.value;
  }

  @override
  String toString() {
    return "$numerator/$denominator";
  }

  // TODO
  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {

  }

}
