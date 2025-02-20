part of '../flutter_artist.dart';

class SortCriterion {
  SortingDirection direction;
  String propName;

  SortCriterion._({
    required this.direction,
    required this.propName,
  });

  void _setToNone() {
    direction = SortingDirection.none;
  }

  bool isAscending() {
    return direction == SortingDirection.ascending;
  }

  bool isDescending() {
    return direction == SortingDirection.descending;
  }

  SortCriterion copyWith(SortingDirection direction) {
    return SortCriterion._(direction: direction, propName: propName);
  }

  SortCriterion copy() {
    return SortCriterion._(direction: direction, propName: propName);
  }

  SortingDirection getNextDirection() {
    switch (direction) {
      case SortingDirection.ascending:
        return SortingDirection.descending;
      case SortingDirection.descending:
        return SortingDirection.none;
      case SortingDirection.none:
        return SortingDirection.ascending;
    }
  }

  void setNextDirection() {
    direction = getNextDirection();
  }

  static SortCriterion _parse(String sortablePropName) {
    String pn = sortablePropName.trim();
    if (pn.isEmpty) {
      throw Exception("Invalid sortablePropName. Not allow empty");
    }
    String sign = "";
    String propName = pn;
    if (pn.startsWith("+") || pn.startsWith("-")) {
      sign = pn.substring(0, 1);
      propName = pn.substring(1).trim();
    }
    if (propName.isEmpty) {
      throw Exception("Invalid sortablePropName. '$sortablePropName'. "
          "Valid example: 'email', '+email' or '-email'");
    }
    //
    SortingDirection direction = SortingDirection.fromSign(sign);
    return SortCriterion._(
      direction: direction,
      propName: propName,
    );
  }

  @override
  String toString() {
    return "${direction.sign}$propName";
  }
}
