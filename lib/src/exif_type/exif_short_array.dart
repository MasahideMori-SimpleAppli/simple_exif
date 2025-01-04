import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifShortArray extends ExifType {
  final List<ExifShort> value;

  /// * [value] : The data.
  ExifShortArray(this.value) : super(EnumExifType.shortArray);

  @override
  String toString() {
    String r = "";
    for (ExifShort i in value) {
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
    ByteData byteData = ByteData(value.length * 2);
    for (int i = 0; i < value.length; i++) {
      byteData.setUint16(i * 2, value[i].value, endian);
    }
    return byteData.buffer.asUint8List();
  }

  /// The Exif tag count.
  @override
  int count(){
    return value.length;
  }
}
