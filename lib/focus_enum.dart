enum FocusEnum {
  up,
  down,
  left,
  right;

  static FocusEnum fromString(String value) {
    return FocusEnum.values.firstWhere((e) => e.toString() == value);
  }
}
