/// SHORT (0〜65535)
class ExifShort {
  final int value;

  /// * [value] : 0〜65535 (16bit).
  ExifShort(this.value) {
    if (value < 0 || value > 65535) {
      throw RangeError('Value must be between 0 and 65535: $value');
    }
  }

  @override
  String toString() => value.toString();
}
