import 'package:simple_exif/simple_exif.dart';

class ExifAsciiCodeArray extends ExifType {
  final List<ExifAsciiCode> value;

  ExifAsciiCodeArray(this.value) : super(EnumExifType.asciiCodeArray);

  // TODO 利便性のためにfromStrメソッドが必要。

  @override
  String toString() {
    String r = "";
    for (ExifAsciiCode i in value) {
      r += i.toString();
    }
    return r;
  }
}
