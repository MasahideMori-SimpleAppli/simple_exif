import 'dart:typed_data';

import 'package:simple_exif/simple_exif.dart';

class ExifLongArray extends ExifType {
  final List<ExifLong> value;

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
    List<int> r = [];
    for (ExifLong i in value) {
      r.add(i.value);
    }
    // バイト列バッファを作成
    ByteData byteData = ByteData(r.length * 4);
    // バイト列に変換
    for (int i = 0; i < r.length; i++) {
      byteData.setUint32(i * 4, r[i], Endian.big);
    }
    // Uint8Listに変換
    return byteData.buffer.asUint8List();
  }

  /// The Exif tag count.
  @override
  int count(){
    return value.length;
  }
}
