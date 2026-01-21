part of '../core.dart';

class SortCriterion extends Equatable {
  final String criterionNameTilde;
  final String _text;
  final String? translationKey;
  final bool skipNonDirectionWhileSelecting;
  SortDirection? _direction;

  SortDirection? _initialDirection;
  SortDirection? _lastUsedDirection;

  SortDirection? get initialDirection => _initialDirection;

  SortDirection? get lastUsedDirection => _lastUsedDirection;

  String get text => _text;

  SortDirection? get direction => _direction;

  SortCriterion._({
    required SortDirection? direction,
    required this.criterionNameTilde,
    required this.skipNonDirectionWhileSelecting,
    required this.translationKey,
    required String text,
  })  : _text = text,
        _direction = direction,
        _initialDirection = direction,
        _lastUsedDirection = direction;

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
    return "${_direction == null ? '' : _direction!.sign}$criterionNameTilde";
  }

  SortCriterion copyWith({required SortDirection direction}) {
    return SortCriterion._(
      criterionNameTilde: criterionNameTilde,
      skipNonDirectionWhileSelecting: skipNonDirectionWhileSelecting,
      translationKey: translationKey,
      text: text,
      direction: direction,
    );
  }

  SortCriterion copy() {
    return SortCriterion._(
      criterionNameTilde: criterionNameTilde,
      skipNonDirectionWhileSelecting: skipNonDirectionWhileSelecting,
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
        return skipNonDirectionWhileSelecting ? SortDirection.asc : null;
      case null:
        return SortDirection.asc;
    }
  }

  @override
  List<Object?> get props => [criterionNameTilde, _direction];

  @override
  String toString() {
    return "${direction == null ? '' : direction!.sign}$criterionNameTilde";
  }
}
