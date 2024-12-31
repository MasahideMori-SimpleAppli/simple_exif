import 'dart:typed_data';

import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

/// BYTE (0〜255)
class ExifByte extends ExifType{
  final int value;

  ExifByte(this.value) : super(EnumExifType.byte) {
    if (value < 0 || value > 255) {
      throw RangeError('Value must be between 0 and 255: $value');
    }
  }

  @override
  String toString() => value.toString();

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    List<int> r = [value];
    return Uint8List.fromList(r);
  }
}