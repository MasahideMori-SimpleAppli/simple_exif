import 'dart:typed_data';

import 'package:simple_exif/simple_exif.dart';

class ExifAsciiCode extends ExifType {
  final int value;

  ExifAsciiCode(this.value) : super(EnumExifType.asciiCode);

  @override
  String toString() => String.fromCharCodes([value]);

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    List<int> r = [value];
    // add null code
    r.add(0);
    return Uint8List.fromList(r);
  }

  /// The Exif tag count.
  @override
  int count(){
    // code + null code.
    return 2;
  }
}
