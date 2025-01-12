/// (en) Definition of the data types used by TIFF and Exif.
/// However, in this package, anything with a count greater than 1
/// is defined as an array type.
///
/// (ja) TIFF及びExifで取り扱われるデータ型の定義。
/// ただし、このパッケージではカウントが１以上のものは配列型として定義しています。
enum EnumExifDataType {
  byte,
  short,
  long,
  rational, // 2 LONG values: numerator and denominator
  undefined,
  slong,
  srational,
  // The following are types for handling arrays of lengths corresponding to tags.
  asciiCodeArray,
  byteArray,
  shortArray,
  longArray,
  rationalArray,
  slongArray,
  srationalArray,
  // tiff only tags
  float,
  double,
  floatArray,
  doubleArray,
}

extension ExtEnumExifType on EnumExifDataType {
  /// Convert to int value of Exif data type.
  int toInt() {
    switch (this) {
      case EnumExifDataType.byte:
      case EnumExifDataType.byteArray:
        return 1;
      case EnumExifDataType.asciiCodeArray:
        return 2;
      case EnumExifDataType.short:
      case EnumExifDataType.shortArray:
        return 3;
      case EnumExifDataType.long:
      case EnumExifDataType.longArray:
        return 4;
      case EnumExifDataType.rational:
      case EnumExifDataType.rationalArray:
        return 5;
      case EnumExifDataType.undefined:
        return 7;
      case EnumExifDataType.slong:
      case EnumExifDataType.slongArray:
        return 9;
      case EnumExifDataType.srational:
      case EnumExifDataType.srationalArray:
        return 10;
      case EnumExifDataType.float:
      case EnumExifDataType.floatArray:
        return 11;
      case EnumExifDataType.double:
      case EnumExifDataType.doubleArray:
        return 12;
    }
  }
}
