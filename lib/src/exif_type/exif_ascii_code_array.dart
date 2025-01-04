import 'dart:typed_data';
import '../../simple_exif.dart';

class ExifAsciiCodeArray extends ExifType {
  final String value;

  /// * [value] : The data.
  ExifAsciiCodeArray(this.value) : super(EnumExifType.asciiCodeArray);

  @override
  String toString() => value;

  @override
  Uint8List? toUint8List({Endian endian = Endian.big}) {
    // NULL終端を含めたバイトリストを作成
    final List<int> r = [...value.codeUnits];
    r.add(0); // NULL終端を追加
    return Uint8List.fromList(r);
  }

  /// The Exif tag count.
  @override
  int count() {
    // NULL終端を含めた文字列の長さ
    return value.length + 1;
  }
}
