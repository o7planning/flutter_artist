part of '../flutter_artist.dart';

enum SortSign {
  plus,
  minus,
  none;

  static SortSign fromSign(String sign) {
    for (SortSign ss in SortSign.values) {
      if (ss.sign == sign) {
        return ss;
      }
    }
    return SortSign.none;
  }
}

extension SortSignExt on SortSign {
  String get sign {
    switch (this) {
      case SortSign.plus:
        return "+";
      case SortSign.minus:
        return "-";
      case SortSign.none:
        return "";
    }
  }
}
