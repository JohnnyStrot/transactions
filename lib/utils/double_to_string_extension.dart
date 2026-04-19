extension DoubleToString on double {
  String toReadableString({int digits = 6}) {
    return toStringAsFixed(digits).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}
