part of '../core.dart';

///
/// Multi Options Criterion with Multi Selections.
///
class MultiOptMsFilterCriterion<V> extends MultiOptFilterCriterion<V> {
  MultiOptMsFilterCriterion({
    required super.criterionNameX,
  }) : super._(selectionType: SelectionType.multi, children: const []);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
