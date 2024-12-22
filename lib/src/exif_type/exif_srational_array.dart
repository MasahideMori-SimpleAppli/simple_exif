import 'package:simple_exif/simple_exif.dart';

class ExifSRationalArray extends ExifType {
  final List<ExifSRational> value;

  ExifSRationalArray(this.value) : super(EnumExifType.srationalArray);

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
}
