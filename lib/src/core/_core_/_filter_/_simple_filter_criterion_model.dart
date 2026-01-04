part of '../core.dart';

class SimpleFilterCriterionModel<V> extends FilterCriterionModel<V> {
  SimpleFilterCriterionModel({
    required super.criterionName,
    required super.operator,
    super.description,
  });

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;

  void _updateTempValue({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      // final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[criterionName];
      //
      _candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }
}
