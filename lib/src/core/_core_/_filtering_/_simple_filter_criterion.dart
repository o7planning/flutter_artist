part of '../core.dart';

class SimpleFilterCriterion<V> extends FilterCriterion<V> {
  SimpleFilterCriterion({
    required super.criterionName,
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
