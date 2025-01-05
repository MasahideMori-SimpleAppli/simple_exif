import 'dart:typed_data';

import 'package:test_all/src/enum/enum_ifd_type.dart';

import '../../simple_exif.dart';

/// (en) This is the parent class for each Exif tag data.
/// It forces child classes to have the data type defined in Enum.
///
/// (ja) 各Exifタグデータの親クラスです。
/// 子クラスに Enum で定義されたデータ型を持たせるように強制します。
class ExifType {
  final EnumExifType dataType;
  final EnumIFDType ifdType;

  /// * [dataType] : Definition of the data types used by TIFF and Exif.
  /// However, in this package, anything with a count greater than 1
  /// is defined as an array type.
  /// * [ifdType] : Defines the type of IFD each tag belongs to.
  ExifType(this.dataType, this.ifdType);

  @override
  String toString() => "ExifType: ${dataType.name}";

  /// Convert it to bytecode and return it.
  /// If there is no value, null is returned.
  /// * [endian] : big or small. default is big.
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    return null;
  }

  /// The Exif tag count.
  int count() {
    return 1;
  }
}
