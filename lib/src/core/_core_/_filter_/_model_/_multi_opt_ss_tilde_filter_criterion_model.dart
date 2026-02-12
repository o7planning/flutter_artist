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
    required super.tildeSuffix,
    required super.defaultSettingPolicy,
    required super.parentMatchSuffix,
    super.children = const [],
  }) : super._(selectionType: SelectionType.single);

  void __checkValue(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is! V) {
      throw FilterCriterionTypeMismatchError(
        tildeCriterionName: tildeCriterionName,
        definedTildeCriterionType: V,
        actualValue: value,
      );
    }
  }

  @override
  set _candidateUpdateValue(dynamic value) {
    __checkValue(value);
    super._candidateUpdateValue = value;
  }

  @override
  set _tempCurrentValue(dynamic value) {
    __checkValue(value);
    super._tempCurrentValue = value;
  }

  @override
  set _currentValue(dynamic value) {
    __checkValue(value);
    super._currentValue = value;
  }

  @override
  set _initialValue(dynamic value) {
    __checkValue(value);
    super._initialValue = value;
  }

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;
}
