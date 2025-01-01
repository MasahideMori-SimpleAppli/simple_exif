import 'dart:typed_data';

import 'package:simple_exif/simple_exif.dart';

class ExifRationalArray extends ExifType {
  final List<ExifRational> value;

  ExifRationalArray(this.value) : super(EnumExifType.rationalArray);

  @override
  String toString() {
    String r = "";
    for (ExifRational i in value) {
      r += i.toString();
      r += ",";
    }
    if (r.isNotEmpty) {
      r = r.substring(0, r.length - 1);
    }
    return r;
  }

  // TODO
  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {

  }

  /// The Exif tag count.
  @override
  int count(){
    return value.length;
  }
}
