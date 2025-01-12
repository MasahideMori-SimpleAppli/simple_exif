import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifSRational extends ExifDataType {
  final ExifSLong numerator;
  final ExifSLong denominator;

  /// * [numerator] : x of x/y.　4 bytes (32-bit signed integer).
  /// * [denominator] : y of x/y. 4 bytes (32-bit signed integer).
  ExifSRational(this.numerator, this.denominator)
      : super(EnumExifDataType.rational) {
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

  @override
  Uint8List toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(8);
    byteData.setInt32(0, numerator.value, endian); // 分子をセット
    byteData.setInt32(4, denominator.value, endian); // 分母をセット
    return byteData.buffer.asUint8List();
  }

  @override
  ExifDataType deepCopy() {
    return ExifSRational(
        numerator.deepCopy() as ExifSLong, denominator.deepCopy() as ExifSLong);
  }
}
