enum SortDirection {
  ascending,
  descending;

  static SortDirection? fromSign(String sign) {
    for (SortDirection ss in SortDirection.values) {
      if (ss.sign == sign) {
        return ss;
      }
    }
    return null;
  }

  String get sqlKeyword {
    switch (this) {
      case SortDirection.ascending:
        return "asc";
      case SortDirection.descending:
        return "desc";
    }
  }

  String get sign {
    switch (this) {
      case SortDirection.ascending:
        return "+";
      case SortDirection.descending:
        return "-";
    }
  }
}
