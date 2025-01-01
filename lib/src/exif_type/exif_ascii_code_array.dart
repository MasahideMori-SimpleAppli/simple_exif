import 'dart:typed_data';

import 'package:simple_exif/simple_exif.dart';

class ExifAsciiCodeArray extends ExifType {
  late final List<ExifAsciiCode> value;

  ExifAsciiCodeArray(this.value) : super(EnumExifType.asciiCodeArray);

  /// Converts a String into an ASCII code array and initializes it.
  /// * [v] : Source text.
  ExifAsciiCodeArray.fromStr(String v) : super(EnumExifType.asciiCodeArray) {
    List<ExifAsciiCode> array = [];
    for (int i in v.runes.toList()) {
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

  // TODO 恐らく修正が必要。
  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    List<int> r = [];
    for (ExifAsciiCode i in value) {
      r.add(i.value);
    }
    // add null code
    r.add(0);
    return Uint8List.fromList(r);
  }

  /// The Exif tag count.
  @override
  int count(){
    // code + null code.
    return value.length + 1;
  }
}
