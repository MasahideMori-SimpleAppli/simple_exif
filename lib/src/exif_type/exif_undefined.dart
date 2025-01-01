import 'dart:typed_data';
import 'package:simple_exif/simple_exif.dart';

class ExifUndefined extends ExifType {
  late final List<int> value;

  ExifUndefined(this.value) : super(EnumExifType.undefined);

  /// Converts an array of ASCII codes to this type.
  /// Unlike ASCII codes, this type does not end with a null code.
  ExifUndefined.fromASCIICodeArray(ExifAsciiCodeArray v)
      : super(EnumExifType.undefined) {
    List<int> r = [];
    for (ExifAsciiCode i in v.value) {
      r.add(i.value);
    }
    value = r;
  }

  @override
  String toString() => String.fromCharCodes(value);

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    return Uint8List.fromList(value);
  }

  /// The Exif tag count.
  @override
  int count(){
    return value.length;
  }
}
