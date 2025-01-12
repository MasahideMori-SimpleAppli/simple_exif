import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifFloat extends ExifDataType {
  final double value;
  static const double minValue = -3.4028235e+38;
  static const double maxValue = 3.4028235e+38;

  /// * [value] : The floating-point number.
  /// The value must be within the IEEE 754 single-precision float range.
  /// If a number outside this range is entered, an exception will be thrown.
  ExifFloat(this.value) : super(EnumExifDataType.float) {
    if (value < minValue || value > maxValue) {
      throw ArgumentError(
          "Value $value is out of range for IEEE 754 single-precision float type.");
    }
  }

  @override
  String toString() => value.toString();

  @override
  Uint8List toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(4);
    byteData.setFloat32(0, value, endian);
    return byteData.buffer.asUint8List();
  }

  @override
  ExifDataType deepCopy() {
    return ExifFloat(value);
  }
}
