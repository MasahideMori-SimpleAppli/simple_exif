import 'package:simple_exif/simple_exif.dart';

class ExifAsciiCodeArray extends ExifType {
  late final List<ExifAsciiCode> value;

  ExifAsciiCodeArray(this.value) : super(EnumExifType.asciiCodeArray);

  /// Converts a String into an ASCII code array and initializes it.
  /// * [v] : Source text.
  ExifAsciiCodeArray.fromStr(String v) : super(EnumExifType.asciiCodeArray){
    List<ExifAsciiCode> array = [];
    for(int i in v.runes.toList()){
      array.add(ExifAsciiCode(i));
    }
    value = array;
  }

  @override
  String toString() {
    String r = "";
    for (ExifAsciiCode i in value) {
      r += i.toString();
    }
    return r;
  }
}
