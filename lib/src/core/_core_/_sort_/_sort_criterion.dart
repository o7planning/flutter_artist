part of '../core.dart';

class SortCriterion extends Equatable {
  final String criterionName;
  final String _text;
  final String? translationKey;
  final bool directionalSelectionOnly;
  SortDirection? _direction;

  SortDirection? _initialDirection;
  SortDirection? _lastUsedDirection;

  SortDirection? get initialDirection => _initialDirection;

  SortDirection? get lastUsedDirection => _lastUsedDirection;

  String get text => _text;

  SortDirection? get direction => _direction;

  SortCriterion._({
    required SortDirection? direction,
    required this.criterionName,
    required this.directionalSelectionOnly,
    required this.translationKey,
    required String text,
  })  : _text = text,
        _direction = direction,
        _initialDirection = direction,
        _lastUsedDirection = direction;

  bool get isAscending {
    return _direction == SortDirection.asc;
  }

  bool get isDescending {
    return _direction == SortDirection.desc;
  }

  bool get hasDirection {
    return _direction != null;
  }

  bool get hasNoDirection {
    return _direction == null;
  }

  String toCriterionString() {
    return "${_direction == null ? '' : _direction!.sign}$criterionName";
  }

  SortCriterion copyWith({required SortDirection direction}) {
    return SortCriterion._(
      criterionName: criterionName,
      directionalSelectionOnly: directionalSelectionOnly,
      translationKey: translationKey,
      text: text,
      direction: direction,
    );
  }

  SortCriterion copy() {
    return SortCriterion._(
      criterionName: criterionName,
      directionalSelectionOnly: directionalSelectionOnly,
      translationKey: translationKey,
      text: text,
      direction: _direction,
    );
  }

  SortDirection? get nextDirection {
    switch (_direction) {
      case SortDirection.asc:
        return SortDirection.desc;
      case SortDirection.desc:
        return directionalSelectionOnly ? SortDirection.asc : null;
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
