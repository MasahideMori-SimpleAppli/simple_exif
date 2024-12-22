import 'dart:typed_data';
import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';
import 'package:simple_exif/src/exif_type/exif_type.dart';

class ExifUndefined extends ExifType{
  final Uint8List value;

  ExifUndefined(this.value) : super(EnumExifType.undefined);

  @override
  String toString() => value.toString();
}