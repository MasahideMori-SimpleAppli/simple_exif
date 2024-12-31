import 'dart:typed_data';

import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

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

  // TODO
  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {

  }
}
