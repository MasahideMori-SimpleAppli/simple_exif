/// BYTE (0〜255)
class ExifByte {
  final int value;

  ExifByte(this.value) {
    if (value < 0 || value > 255) {
      throw RangeError('Value must be between 0 and 255: $value');
    }
  }

  @override
  String toString() => value.toString();
}