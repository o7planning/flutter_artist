part of '../core.dart';

class SimpleFormProp<V> extends FormProp<V> {
  SimpleFormProp({
    required super.propName,
  });

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;

  static List<SimpleFormProp> listFromNames(List<String> propNames) {
    return propNames
        .map(
          (name) => SimpleFormProp(propName: name),
        )
        .toList();
  }

  void _updateTempValue({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      // final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[propName];
      //
      _candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }
}
