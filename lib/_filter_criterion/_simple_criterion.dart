part of '../flutter_artist.dart';

class SimpleCriterion extends Criterion {
  SimpleCriterion({
    required super.propName,
  });

  void _updateTempValue({
    required Map<String, dynamic> tempCurrentFormData,
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _dirty) {
      final dynamic oldValue = tempCurrentFormData[propName];
      final dynamic newValue = updateValues[propName];
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
