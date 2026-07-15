enum SortDirection {
  asc,
  desc;

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
      case SortDirection.asc:
        return "asc";
      case SortDirection.desc:
        return "desc";
    }
  }

  String get sign {
    switch (this) {
      case SortDirection.asc:
        return "+";
      case SortDirection.desc:
        return "-";
    }
  }
}
