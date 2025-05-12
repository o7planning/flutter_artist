part of '../../flutter_artist.dart';

class SimpleCriterion extends Criterion {
  SimpleCriterion({
    required super.criterionName,
  });

  void _updateTempValue({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      // final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[criterionName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }

  @override
  void _resetForNewTransaction() {
    // Do nothing.
  }

  @override
  void _applyTempDataToReal() {
    // Do nothing.
  }
}
