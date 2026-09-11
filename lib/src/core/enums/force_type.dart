enum FormForceType {
  force(2),
  forceIfNeed(1),
  auto(0);

  final int value;

  const FormForceType(this.value);

  bool greaterThan(FormForceType other) {
    return value > other.value;
  }

  bool lessThan(FormForceType other) {
    return value < other.value;
  }
}
