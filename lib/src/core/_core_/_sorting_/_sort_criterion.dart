part of '../core.dart';

class SortCriterion extends Equatable {
  final String criterionName;
  final String _text;
  final String? translationKey;
  final bool acceptNonDirection;
  SortDirection? _direction;

  String get text => _text;

  SortDirection? get direction => _direction;

  SortCriterion._({
    required SortDirection? direction,
    required this.criterionName,
    required this.acceptNonDirection,
    required this.translationKey,
    required String text,
  })  : _text = text,
        _direction = direction;

  bool isAscending() {
    return _direction == SortDirection.asc;
  }

  bool isDescending() {
    return _direction == SortDirection.desc;
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
      acceptNonDirection: acceptNonDirection,
      translationKey: translationKey,
      text: text,
      direction: direction,
    );
  }

  SortCriterion copy() {
    return SortCriterion._(
      criterionName: criterionName,
      acceptNonDirection: acceptNonDirection,
      translationKey: translationKey,
      text: text,
      direction: _direction,
    );
  }

  SortDirection? getNextDirection() {
    switch (_direction) {
      case SortDirection.asc:
        return SortDirection.desc;
      case SortDirection.desc:
        return acceptNonDirection ? null : SortDirection.asc;
      case null:
        return SortDirection.asc;
    }
  }

  @override
  List<Object?> get props => [criterionName, _direction];

  @override
  String toString() {
    return "${direction == null ? '' : direction!.sign}$criterionName";
  }
}
