part of '../core.dart';

///
/// Multi Options Criterion with Multi Selections.
///
class MultiOptMsFilterCriterionModel<V>
    extends MultiOptFilterCriterionModel<V> {
  MultiOptMsFilterCriterionModel({
    required super.criterionNamePlus,
  }) : super._(selectionType: SelectionType.multi);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
