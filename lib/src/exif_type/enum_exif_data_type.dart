enum EnumExifType {
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

extension ExtEnumExifType on EnumExifType {
  /// Convert to int value of Exif data type.
  int toInt() {
    switch (this) {
      case EnumExifType.byte:
      case EnumExifType.byteArray:
        return 1;
      case EnumExifType.asciiCodeArray:
        return 2;
      case EnumExifType.short:
      case EnumExifType.shortArray:
        return 3;
      case EnumExifType.long:
      case EnumExifType.longArray:
        return 4;
      case EnumExifType.rational:
      case EnumExifType.rationalArray:
        return 5;
      case EnumExifType.undefined:
        return 7;
      case EnumExifType.slong:
      case EnumExifType.slongArray:
        return 9;
      case EnumExifType.srational:
      case EnumExifType.srationalArray:
        return 10;
      case EnumExifType.float:
      case EnumExifType.floatArray:
        return 11;
      case EnumExifType.double:
      case EnumExifType.doubleArray:
        return 12;
    }
  }
}
