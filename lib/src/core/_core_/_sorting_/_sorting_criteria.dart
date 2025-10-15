part of '../core.dart';

class SortingCriteria extends Equatable {
  final List<SortingCriterion> _criteria;

  SortingCriteria._(List<SortingCriterion> criteria)
      : _criteria = [...criteria];

  @override
  List<Object?> get props => [..._criteria];
}
