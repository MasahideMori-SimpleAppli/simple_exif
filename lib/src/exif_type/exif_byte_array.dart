import 'package:simple_exif/simple_exif.dart';

class ExifByteArray extends ExifType {
  final List<ExifByte> value;

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
}
