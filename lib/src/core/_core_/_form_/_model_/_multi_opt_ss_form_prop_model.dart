part of '../../core.dart';

class MultiOptSsFormPropModel<V> extends MultiOptFormPropModel<V> {
  MultiOptSsFormPropModel({
    required super.parent,
    required super.propName,
    required super.reloadCondition,
  }) : super._(selectionType: SelectionType.single);

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;

  void __checkValue(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is! V) {
      throw FormPropTypeMismatchError(
        propName: propName,
        definedPropType: V,
        actualValue: value,
      );
    }
  }

  @override
  set _candidateUpdateValue(dynamic value) {
    __checkValue(value);
    super._candidateUpdateValue = value;
  }

  @override
  set _tempCurrentValue(dynamic value) {
    __checkValue(value);
    super._tempCurrentValue = value;
  }

  @override
  set _currentValue(dynamic value) {
    __checkValue(value);
    super._currentValue = value;
  }

  @override
  set _initialValue(dynamic value) {
    __checkValue(value);
    super._initialValue = value;
  }
}
