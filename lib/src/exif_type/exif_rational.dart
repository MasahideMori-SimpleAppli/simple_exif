import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifRational extends ExifType {
  final ExifLong numerator;
  final ExifLong denominator;

  /// * [numerator] : x of x/y.　4 bytes (32-bit unsigned integer).
  /// * [denominator] : y of x/y. 4 bytes (32-bit unsigned integer).
  ExifRational(this.numerator, this.denominator)
      : super(EnumExifType.rational) {
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
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(8);
    byteData.setUint32(0, numerator.value, endian); // 分子をセット
    byteData.setUint32(4, denominator.value, endian); // 分母をセット
    return byteData.buffer.asUint8List();
  }
}
