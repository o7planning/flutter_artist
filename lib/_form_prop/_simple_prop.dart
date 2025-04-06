part of '../flutter_artist.dart';

class SimpleProp extends Prop {
  SimpleProp({
    required super.propName,
  });

  void _updateTempValue({
    required Map<String, dynamic> tempCurrentFormData,
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      final dynamic oldValue = tempCurrentFormData[propName];
      final dynamic newValue = updateValues[propName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }

}
