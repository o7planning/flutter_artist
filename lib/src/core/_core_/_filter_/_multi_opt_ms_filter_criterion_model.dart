part of '../core.dart';

///
/// Multi Options Criterion with Multi Selections.
///
class MultiOptMsFilterCriterionModel<V>
    extends MultiOptFilterCriterionModel<V> {
  MultiOptMsFilterCriterionModel({
    required super.criterionName,
    required super.operator,
  }) : super._(selectionType: SelectionType.multi, children: const []);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
