enum FormLoadHint {
  force(2),
  forceIfNeed(1),
  auto(0);

  final int value;

  const FormLoadHint(this.value);

  bool greaterThan(FormLoadHint other) {
    return value > other.value;
  }

  bool lessThan(FormLoadHint other) {
    return value < other.value;
  }
}
