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

  void __checkValue(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is! List) {
      throw FilterMultiOptMsMismatchError(
        tildeCriterionName: tildeCriterionName,
        definedTildeCriterionType: V,
        actualValue: value,
      );
    }
    value as List;
    for (dynamic v in value) {
      if (v is! V?) {
        throw FilterCriterionTypeMismatchError(
          tildeCriterionName: tildeCriterionName,
          definedTildeCriterionType: V,
          actualValue: v,
        );
      }
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
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
