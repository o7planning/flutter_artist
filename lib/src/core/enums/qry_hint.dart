enum QryHint {
  force(2),
  @Deprecated("No longer use")
  markAsPending(1),
  none(0);

  final int value;

  const QryHint(this.value);

  bool isLessThan(QryHint other) {
    return value < other.value;
  }
}
