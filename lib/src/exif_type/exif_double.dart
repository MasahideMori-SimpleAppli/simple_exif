import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifDouble extends ExifType {
  final double value;

  /// * [value] : The floating-point number.
  ExifDouble(this.value) : super(EnumExifType.double);

  @override
  String toString() => value.toString();

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(8);
    byteData.setFloat64(0, value, endian);
    return byteData.buffer.asUint8List();
  }
}
