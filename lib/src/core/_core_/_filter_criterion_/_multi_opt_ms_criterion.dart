part of '../core.dart';

///
/// Multi Options Criterion with Multi Selections.
///
class MultiOptMsCriterion<V> extends MultiOptCriterion<V> {
  MultiOptMsCriterion({
    required super.criterionName,
  }) : super._(selectionType: SelectionType.multi, children: const []);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
