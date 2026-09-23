enum QueryHint {
  force(1),
  none(0);

  final int value;

  const QueryHint(this.value);

  bool isLessThan(QueryHint other) {
    return value < other.value;
  }

  static QueryHint max(QueryHint a, QueryHint b) {
    if (a.isLessThan(b)) {
      return b;
    }
    return a;
  }
}

enum FilterLoadHint {
  force,
  auto;
}

enum FormProcessHint {
  force,
  auto;
}

enum ExecHint {
  force(1),
  none(0);

  final int value;

  const ExecHint(this.value);

  bool isLessThan(ExecHint other) {
    return value < other.value;
  }

  static ExecHint max(ExecHint a, ExecHint b) {
    if (a.isLessThan(b)) {
      return b;
    }
    return a;
  }
}
