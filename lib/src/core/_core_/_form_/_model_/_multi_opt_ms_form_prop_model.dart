part of '../../core.dart';

class MultiOptMsFormPropModel<V> extends MultiOptFormPropModel<V> {
  MultiOptMsFormPropModel({
    required super.parent,
    required super.propName,
    required super.reloadCondition,
  }) : super._(selectionType: SelectionType.multi);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;

  void __checkValue(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is! List) {
      throw FormMultiOptMsMismatchError(
        propName: propName,
        definedPropType: V,
        actualValue: value,
      );
    }
    value as List;
    for (dynamic v in value) {
      if (v == null) {
        continue;
      }
      if (v is! V) {
        throw FormPropTypeMismatchError(
          propName: propName,
          definedPropType: V,
          actualValue: v,
        );
      }
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
