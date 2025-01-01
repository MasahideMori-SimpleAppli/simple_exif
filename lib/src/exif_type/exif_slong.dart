import 'dart:typed_data';

import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

class ExifSLong extends ExifType{
  final int value;

  /// * [value] : The long type number.
  /// If a number outside this range is entered, an exception will be thrown.
  ExifSLong(this.value) : super(EnumExifType.long) {
    if (value < -2147483648 || value > 2147483647) {
      throw ArgumentError("Value $value is out of range for SLONG type.");
    }
  }

  @override
  String toString() => value.toString();

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(4);
    byteData.setInt32(0, value, endian); // 符号あり32ビット整数
    return byteData.buffer.asUint8List();
  }
}
