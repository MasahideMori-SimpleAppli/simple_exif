import 'dart:typed_data';
import '../../simple_exif.dart';

/// (en) This is the parent class for each Exif tag data.
/// It forces child classes to have the data type defined in Enum.
///
/// (ja) 各Exifタグデータの親クラスです。
/// 子クラスに Enum で定義されたデータ型を持たせるように強制します。
abstract class ExifDataType {
  final EnumExifDataType dataType;

  /// * [dataType] : Definition of the data types used by TIFF and Exif.
  /// However, in this package, anything with a count greater than 1
  /// is defined as an array type.
  ExifDataType(this.dataType);

  @override
  String toString() => "ExifDataType: ${dataType.name}";

  /// Convert it to bytecode and return it.
  /// If there is no value, null is returned.
  /// * [endian] : big or small. default is big.
  Uint8List toUint8List({Endian endian = Endian.big});

  /// The Exif tag count.
  int count() {
    return 1;
  }

  /// Return deep copy data.
  ExifDataType deepCopy();
}
