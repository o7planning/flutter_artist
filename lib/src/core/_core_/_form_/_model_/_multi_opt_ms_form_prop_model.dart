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
}
