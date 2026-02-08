part of '../../core.dart';

///
/// Multi Options TildeCriterion with Multi Selections.
///
class MultiOptMsTildeFilterCriterionModel<V>
    extends MultiOptTildeFilterCriterionModel<V> {
  MultiOptMsTildeFilterCriterionModel({
    required super.parent,
    required super.tildeCriterionName,
    required super.criterionName,
    required super.tildeSuffix,
    required super.defaultSettingPolicy,
    required super.parentMatchSuffix,
  }) : super._(selectionType: SelectionType.multi, children: const []);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
