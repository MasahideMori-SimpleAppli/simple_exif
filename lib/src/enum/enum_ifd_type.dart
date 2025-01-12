/// (en) Defines the type of IFD each tag belongs to.
///
/// (ja) 各タグの所属するIFDのタイプの定義。
enum EnumIFDType {
  tiff, // 0th IFD
  exif,
  interoperability, // IO IFD
  gps,
  first // 1st IFD
}
