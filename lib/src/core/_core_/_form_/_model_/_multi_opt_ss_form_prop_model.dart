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
}
