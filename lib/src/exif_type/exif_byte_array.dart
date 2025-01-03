import 'dart:typed_data';

import 'package:simple_exif/simple_exif.dart';

class ExifByteArray extends ExifType {
  final List<ExifByte> value;

  /// * [value] : The data.
  ExifByteArray(this.value) : super(EnumExifType.byteArray);

  @override
  String toString() {
    String r = "";
    for (ExifByte i in value) {
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
    ByteData byteData = ByteData(value.length);
    for (int i = 0; i < value.length; i++) {
      byteData.setUint8(i, value[i].value); // 各値をセット
    }
    return byteData.buffer.asUint8List();
  }

  /// The Exif tag count.
  @override
  int count(){
    return value.length;
  }
}
