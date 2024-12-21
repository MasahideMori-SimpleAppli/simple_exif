class ExifLong {
  final int value;

  /// * [value] : The long type number.
  /// If a number outside this range is entered, an exception will be thrown.
  ExifLong(this.value) {
    if (value < -2147483648 || value > 2147483647) {
      throw ArgumentError("Value $value is out of range for LONG type.");
    }
  }

  @override
  String toString() => value.toString();
}
