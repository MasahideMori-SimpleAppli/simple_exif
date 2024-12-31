import 'dart:typed_data';

import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

class ExifLong extends ExifType {
  final int value;

  /// * [value] : The long type number.
  /// If a number outside this range is entered, an exception will be thrown.
  ExifLong(this.value) : super(EnumExifType.long) {
    if (value < 0 || value > 4294967295) {
      throw ArgumentError("Value $value is out of range for LONG type.");
    }
  }

  @override
  String toString() => value.toString();

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    List<int> r = [value];
    // バイト列バッファを作成
    ByteData byteData = ByteData(r.length * 4);
    // バイト列に変換
    for (int i = 0; i < r.length; i++) {
      byteData.setUint32(i * 4, r[i], Endian.big);
    }
    // Uint8Listに変換
    return byteData.buffer.asUint8List();
  }
}
