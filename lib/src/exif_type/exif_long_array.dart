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
}
