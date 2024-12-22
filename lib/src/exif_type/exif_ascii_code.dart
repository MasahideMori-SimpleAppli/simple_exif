import 'package:simple_exif/simple_exif.dart';

class ExifAsciiCode extends ExifType {
  final String value;

  ExifAsciiCode(this.value) : super(EnumExifType.asciiCode);

  @override
  String toString() => value;
}
