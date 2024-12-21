class ExifRational {
  final int numerator;
  final int denominator;

  /// * [numerator] : x of x/y.　4 bytes (32-bit unsigned integer).
  /// * [denominator] : y of x/y. 4 bytes (32-bit unsigned integer).
  ExifRational(this.numerator, this.denominator){
    // 値が32ビット符号なし整数の範囲内かを確認
    if (numerator < 0 || numerator > 0xFFFFFFFF) {
      throw ArgumentError("Numerator must be between 0 and 4294967295.");
    }
    if (denominator < 0 || denominator > 0xFFFFFFFF) {
      throw ArgumentError("Denominator must be between 0 and 4294967295.");
    }
    if (denominator == 0) {
      throw ArgumentError("Denominator cannot be zero.");
    }
  }

  double toDouble() {
    if (denominator == 0) {
      throw ArgumentError("Denominator cannot be zero.");
    }
    return numerator / denominator;
  }

  @override
  String toString() {
    return "$numerator/$denominator";
  }

  // TODO ビッグエンディアンまたはリトルエンディアンから読み取れるように読み取りの実装も必要

}
