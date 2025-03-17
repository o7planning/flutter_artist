part of '../flutter_artist.dart';

class CommonMasterProp extends MasterProp {
  CommonMasterProp({
    required super.propName,
  });

  void _updateValue({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _dirty) {
      final dynamic oldValue = currentValues[propName];
      final dynamic newValue = updateValues[propName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }
}
