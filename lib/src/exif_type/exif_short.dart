import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifShort extends ExifType{
  final int value;

  /// * [value] : 0〜65535 (16bit).
  ExifShort(this.value) : super(EnumExifType.short) {
    if (value < 0 || value > 65535) {
      throw RangeError('Value must be between 0 and 65535: $value');
    }
  }

  @override
  String toString() => value.toString();

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(2);
    byteData.setUint16(0, value, endian); // Endianを指定
    return byteData.buffer.asUint8List();
  }
}
