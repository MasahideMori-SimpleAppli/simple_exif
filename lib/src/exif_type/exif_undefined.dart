import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifUndefined extends ExifDataType {
  late final List<int> value;

  /// * [value] : The data.
  ExifUndefined(this.value) : super(EnumExifDataType.undefined);

  /// Converts an array of ASCII codes to this type.
  /// Unlike ASCII codes, this type does not end with a null code.
  /// * [v] : The data.
  ExifUndefined.fromASCIICodeArray(
    ExifAsciiCodeArray v,
  ) : super(EnumExifDataType.undefined) {
    List<int> r = v.toUint8List().toList();
    if (r.isNotEmpty) {
      r.removeLast();
    }
    value = r;
  }

  @override
  String toString() => String.fromCharCodes(value);

  @override
  Uint8List toUint8List({Endian endian = Endian.big}) {
    return Uint8List.fromList(value);
  }

  /// The Exif tag count.
  @override
  int count() {
    return value.length;
  }

  @override
  ExifDataType deepCopy() {
    return ExifUndefined([...value]);
  }
}
