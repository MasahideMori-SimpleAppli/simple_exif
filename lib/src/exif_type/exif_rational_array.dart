import 'dart:typed_data';

import 'package:simple_exif/simple_exif.dart';

class ExifRationalArray extends ExifType {
  final List<ExifRational> value;

  ExifRationalArray(this.value) : super(EnumExifType.rationalArray);

  @override
  String toString() {
    String r = "";
    for (ExifRational i in value) {
      r += i.toString();
      r += ",";
    }
    if (r.isNotEmpty) {
      r = r.substring(0, r.length - 1);
    }
    return r;
  }

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(value.length * 8);
    // 各要素をセット
    for (int i = 0; i < value.length; i++) {
      int offset = i * 8;
      byteData.setUint32(offset, value[i].numerator.value, endian); // 分子
      byteData.setUint32(offset + 4, value[i].denominator.value, endian); // 分母
    }
    return byteData.buffer.asUint8List();
  }

  /// The Exif tag count.
  @override
  int count() {
    return value.length;
  }
}
