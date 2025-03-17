part of '../flutter_artist.dart';

class CommonMasterProp extends MasterProp {
  CommonMasterProp({
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
    // TODO: implement _resetForNewTransaction
  }

  @override
  void _applyTempDataToReal() {
    // TODO: implement _applyTempDataToReal
  }
}
