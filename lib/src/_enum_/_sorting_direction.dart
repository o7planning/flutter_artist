part of '../../flutter_artist.dart';

enum SortingDirection {
  ascending,
  descending,
  none;

  static SortingDirection fromSign(String sign) {
    for (SortingDirection ss in SortingDirection.values) {
      if (ss.sign == sign) {
        return ss;
      }
    }
    return SortingDirection.none;
  }
}

extension SortingDirectionExt on SortingDirection {
  String get sign {
    switch (this) {
      case SortingDirection.ascending:
        return "+";
      case SortingDirection.descending:
        return "-";
      case SortingDirection.none:
        return "";
    }
  }
}
