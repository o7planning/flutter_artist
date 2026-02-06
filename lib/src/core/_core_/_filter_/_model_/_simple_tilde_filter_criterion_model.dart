part of '../../core.dart';

class SimpleTildeFilterCriterionModel<V> extends TildeFilterCriterionModel<V> {
  SimpleTildeFilterCriterionModel({
    required super.tildeCriterionName,
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
      final dynamic newValue = updateValues[tildeCriterionName];
      //
      _candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }
}
