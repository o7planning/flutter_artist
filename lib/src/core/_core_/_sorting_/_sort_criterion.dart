part of '../core.dart';

class SortCriterion extends Equatable {
  final String criterionName;
  String _text;
  SortDirection? _direction;

  String get text => _text;

  SortDirection? get direction => _direction;

  SortCriterion._({
    required SortDirection? direction,
    required this.criterionName,
    required String text,
  })  : _text = text,
        _direction = direction;

  bool isAscending() {
    return _direction == SortDirection.ascending;
  }

  bool isDescending() {
    return _direction == SortDirection.descending;
  }

  bool hasDirection() {
    return _direction != null;
  }

  bool hasNoDirection() {
    return _direction == null;
  }

  String toCriterionString() {
    return "${_direction == null ? '' : _direction!.sign}$criterionName";
  }

  SortCriterion copyWith({required SortDirection direction}) {
    return SortCriterion._(
      criterionName: criterionName,
      text: text,
      direction: direction,
    );
  }

  SortCriterion copy() {
    return SortCriterion._(
      criterionName: criterionName,
      text: text,
      direction: _direction,
    );
  }

  SortDirection? getNextDirection({bool acceptNoneDirection = true}) {
    switch (_direction) {
      case SortDirection.ascending:
        return SortDirection.descending;
      case SortDirection.descending:
        return acceptNoneDirection ? null : SortDirection.ascending;
      case null:
        return SortDirection.ascending;
    }
  }

  static SortCriterion _parse(String sortableCriterionName) {
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
    SortDirection? direction = SortDirection.fromSign(sign);
    return SortCriterion._(
      direction: direction,
      criterionName: criterionName,
      text: criterionName,
    );
  }

  @override
  List<Object?> get props => [criterionName, _direction];

  @override
  String toString() {
    return "${direction == null ? '' : direction!.sign}$criterionName";
  }
}
