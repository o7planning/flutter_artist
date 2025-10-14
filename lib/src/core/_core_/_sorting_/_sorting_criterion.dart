part of '../core.dart';

class SortingCriterion {
  final String criterionName;
  String _text;
  SortingDirection _direction;

  String get text => _text;

  SortingDirection get direction => _direction;

  SortingCriterion._({
    required SortingDirection direction,
    required this.criterionName,
    required String text,
  })  : _text = text,
        _direction = direction;

  bool isAscending() {
    return _direction == SortingDirection.ascending;
  }

  bool isDescending() {
    return _direction == SortingDirection.descending;
  }

  bool isNonDirection() {
    return _direction == SortingDirection.none;
  }

  SortingCriterion copyWith({required SortingDirection direction}) {
    return SortingCriterion._(
      criterionName: criterionName,
      text: text,
      direction: direction,
    );
  }

  SortingCriterion copy() {
    return SortingCriterion._(
      criterionName: criterionName,
      text: text,
      direction: _direction,
    );
  }

  SortingDirection getNextDirection({bool acceptNoneDirection = true}) {
    switch (_direction) {
      case SortingDirection.ascending:
        return SortingDirection.descending;
      case SortingDirection.descending:
        return acceptNoneDirection
            ? SortingDirection.none
            : SortingDirection.ascending;
      case SortingDirection.none:
        return SortingDirection.ascending;
    }
  }

  static SortingCriterion _parse(String sortableCriterionName) {
    String name = sortableCriterionName.trim();
    if (name.isEmpty) {
      throw Exception("Invalid sortableCriterionName. Not allow empty");
    }
    String sign = "";
    String criterionName = name;
    if (name.startsWith("+") || name.startsWith("-")) {
      sign = name.substring(0, 1);
      criterionName = name.substring(1).trim();
    }
    if (criterionName.isEmpty) {
      throw Exception(
          "Invalid sortableCriterionName. '$sortableCriterionName'. "
          "Valid example: 'email', '+email' or '-email'");
    }
    //
    SortingDirection direction = SortingDirection.fromSign(sign);
    return SortingCriterion._(
      direction: direction,
      criterionName: criterionName,
      text: criterionName,
    );
  }

  @override
  String toString() {
    return "${direction.sign}$criterionName";
  }
}
