part of '../../core.dart';

///
/// Multi Options TildeCriterion with Single Selection.
///
class MultiOptSsTildeFilterCriterionModel<V>
    extends MultiOptTildeFilterCriterionModel<V> {
  MultiOptSsTildeFilterCriterionModel({
    required super.parent,
    required super.tildeCriterionName,
    required super.criterionName,
    super.children = const [],
  }) : super._(selectionType: SelectionType.single);

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;
}
