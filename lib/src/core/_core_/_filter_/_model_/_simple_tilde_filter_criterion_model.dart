part of '../../core.dart';

class SimpleTildeFilterCriterionModel<V> extends TildeFilterCriterionModel<V> {
  SimpleTildeFilterCriterionModel({
    required super.tildeCriterionName,
    required super.criterionName,
    required super.tildeSuffix,
  });

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

  void _updateTempValue({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      // final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[tildeCriterionName];
      //
      _candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }
}
