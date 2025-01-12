import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifDoubleArray extends ExifDataType {
  final List<ExifDouble> value;

  /// * [value] : The data.
  ExifDoubleArray(this.value) : super(EnumExifDataType.doubleArray);

  @override
  String toString() {
    String r = "";
    for (ExifDouble i in value) {
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
      byteData.setFloat64(i * 8, value[i].value, endian); // 各値をセット
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
    List<ExifDouble> r = [];
    for (ExifDouble i in value) {
      r.add(i.deepCopy() as ExifDouble);
    }
    return ExifDoubleArray(r);
  }
}
