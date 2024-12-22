import 'package:simple_exif/simple_exif.dart';

class ExifSLongArray extends ExifType {
  final List<ExifSLong> value;

  ExifSLongArray(this.value) : super(EnumExifType.slongArray);

  @override
  String toString() {
    String r = "";
    for (ExifSLong i in value) {
      r += i.toString();
      r += ",";
    }
    if (r.isNotEmpty) {
      r = r.substring(0, r.length - 1);
    }
    return r;
  }
}
