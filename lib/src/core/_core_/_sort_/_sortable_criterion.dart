part of '../core.dart';

class SortableCriterion extends Equatable {
  final String criterionName;

  SortDirection _direction;

  SortDirection get direction => _direction;

  SortableCriterion._({
    required SortDirection direction,
    required this.criterionName,
  }) : _direction = direction;

  bool isAscending() {
    return _direction == SortDirection.asc;
  }

  bool isDescending() {
    return _direction == SortDirection.desc;
  }

  String toCriterionString() {
    return "${_direction.sign}$criterionName";
  }

  @override
  List<Object?> get props => [criterionName, _direction];

  @override
  String toString() {
    return "${_direction.sign}$criterionName";
  }
}
