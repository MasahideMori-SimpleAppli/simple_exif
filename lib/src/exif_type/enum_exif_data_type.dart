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
  srationalArray
}
