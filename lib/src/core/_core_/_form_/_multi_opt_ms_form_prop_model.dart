part of '../core.dart';

class MultiOptMsFormPropModel<V> extends MultiOptFormPropModel<V> {
  MultiOptMsFormPropModel({
    required super.propName,
    super.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  }) : super._(selectionType: SelectionType.multi, children: const []);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
