part of '../core.dart';

class SimpleProp<V> extends Prop<V> {
  SimpleProp({
    required super.propName,
  });

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;

  static List<SimpleProp> listFromNames(List<String> propNames) {
    return propNames
        .map(
          (name) => SimpleProp(propName: name),
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
