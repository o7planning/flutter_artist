part of '../core.dart';

class SimpleCriterion<V> extends Criterion<V> {
  SimpleCriterion({
    required super.criterionName,
  });

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;

  static List<SimpleCriterion> listFromNames(List<String> criterionNames) {
    return criterionNames
        .map(
          (name) => SimpleCriterion(criterionName: name),
        )
        .toList();
  }

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
