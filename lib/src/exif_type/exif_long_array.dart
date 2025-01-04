import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifLongArray extends ExifType {
  final List<ExifLong> value;

  /// * [value] : The data.
  ExifLongArray(this.value) : super(EnumExifType.longArray);

  @override
  String toString() {
    String r = "";
    for (ExifLong i in value) {
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
    ByteData byteData = ByteData(value.length * 4);
    for (int i = 0; i < value.length; i++) {
      byteData.setUint32(i * 4, value[i].value, endian); // 各値をセット
    }
    return byteData.buffer.asUint8List();
  }

  /// The Exif tag count.
  @override
  int count() {
    return value.length;
  }
}
