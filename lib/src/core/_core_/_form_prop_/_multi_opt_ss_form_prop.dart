part of '../core.dart';

class MultiOptSsFormProp<V> extends MultiOptFormProp<V> {
  MultiOptSsFormProp({
    required super.propName,
    super.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
    super.children = const [],
  }) : super._(selectionType: SelectionType.single);

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;
}
