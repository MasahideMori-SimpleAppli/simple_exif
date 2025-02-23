import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifLong extends ExifDataType {
  final int value;

  /// * [value] : The long type number.
  /// If a number outside this range is entered, an exception will be thrown.
  ExifLong(this.value) : super(EnumExifDataType.long) {
    if (value < 0 || value > 4294967295) {
      throw ArgumentError("Value $value is out of range for LONG type.");
    }
  }

  @override
  String toString() => value.toString();

  @override
  Uint8List toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(4);
    byteData.setUint32(0, value, endian);
    return byteData.buffer.asUint8List();
  }

  @override
  ExifDataType deepCopy() {
    return ExifLong(value);
  }
}
