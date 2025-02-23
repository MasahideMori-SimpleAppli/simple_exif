import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifSRationalArray extends ExifDataType {
  final List<ExifSRational> value;

  /// * [value] : The data.
  ExifSRationalArray(this.value) : super(EnumExifDataType.srationalArray);

  @override
  String toString() {
    String r = "";
    for (ExifSRational i in value) {
      r += i.toString();
      r += ",";
    }
    if (r.isNotEmpty) {
      r = r.substring(0, r.length - 1);
    }
    return r;
  }

  @override
  Uint8List toUint8List({Endian endian = Endian.big}) {
    ByteData byteData = ByteData(value.length * 8);
    for (int i = 0; i < value.length; i++) {
      int offset = i * 8;
      byteData.setInt32(offset, value[i].numerator.value, endian); // 分子
      byteData.setInt32(offset + 4, value[i].denominator.value, endian); // 分母
    }
    return byteData.buffer.asUint8List();
  }

  /// The Exif tag count.
  @override
  int count() {
    return value.length;
  }

  @override
  ExifDataType deepCopy() {
    List<ExifSRational> r = [];
    for (ExifSRational i in value) {
      r.add(i.deepCopy() as ExifSRational);
    }
    return ExifSRationalArray(r);
  }
}
