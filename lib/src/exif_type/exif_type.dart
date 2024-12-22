import 'package:simple_exif/src/exif_type/enum_exif_data_type.dart';

/// (en) This is the parent class for each Exif tag data.
/// It forces child classes to have the data type defined in Enum.
///
/// (ja) 各Exifタグデータの親クラスです。
/// 子クラスに Enum で定義されたデータ型を持たせるように強制します。
class ExifType {
  final EnumExifType dataType;

  ExifType(this.dataType);

  @override
  String toString() => "ExifType: ${dataType.name}";
}