part of '../core.dart';

class MultiOptSsProp<V> extends MultiOptProp<V> {
  MultiOptSsProp({
    required super.propName,
    super.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
    super.children = const [],
  }) : super._(selectionType: SelectionType.single);

  @override
  V? get currentValue => _currentValue;

  @override
  V? get initialValue => _initialValue;
}
