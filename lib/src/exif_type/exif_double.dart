import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifDouble extends ExifDataType {
  final double value;

  /// * [value] : The floating-point number.
  ExifDouble(this.value) : super(EnumExifDataType.double);

  @override
  String toString() => value.toString();

  @override
  Uint8List toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(8);
    byteData.setFloat64(0, value, endian);
    return byteData.buffer.asUint8List();
  }

  @override
  ExifDataType deepCopy() {
    return ExifDouble(value);
  }
}
