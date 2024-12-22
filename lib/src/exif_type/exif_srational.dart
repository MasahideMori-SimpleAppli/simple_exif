import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_slong.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

class ExifSRational extends ExifType{
  final ExifSLong numerator;
  final ExifSLong denominator;

  /// * [numerator] : x of x/y.　4 bytes (32-bit signed integer).
  /// * [denominator] : y of x/y. 4 bytes (32-bit signed integer).
  ExifSRational(this.numerator, this.denominator) : super(EnumExifType.rational){
    // 値が32ビット符号なし整数の範囲内かを確認
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

}
