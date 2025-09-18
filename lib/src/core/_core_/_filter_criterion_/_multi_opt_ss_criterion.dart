part of '../core.dart';

///
/// Multi Options Criterion with Single Selection.
///
class MultiOptSsCriterion<V> extends MultiOptCriterion<V> {
  MultiOptSsCriterion({
    required super.criterionName,
    super.children = const [],
  }) : super._(singleSelection: true);

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;
}
