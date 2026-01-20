part of '../../core.dart';

///
/// Multi Options Criterion with Single Selection.
///
class MultiOptSsFilterCriterionModel<V>
    extends MultiOptFilterCriterionModel<V> {
  MultiOptSsFilterCriterionModel({
    required super.parent,
    required super.criterionNameTilde,
    required super.criterionName,
    super.children = const [],
  }) : super._(selectionType: SelectionType.single);

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;
}
