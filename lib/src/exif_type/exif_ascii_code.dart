import 'package:simple_exif/simple_exif.dart';

class ExifAsciiCode extends ExifType {
  final int value;

  ExifAsciiCode(this.value) : super(EnumExifType.asciiCode);

  @override
  String toString() => String.fromCharCodes([value]);
}
