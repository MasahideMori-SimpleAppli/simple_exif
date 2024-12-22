import 'package:simple_exif/simple_exif.dart';

class ExifShortArray extends ExifType {
  final List<ExifShort> value;

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
}