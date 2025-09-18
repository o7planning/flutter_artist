part of '../core.dart';

class MultiOptMsProp<V> extends MultiOptProp<V> {
  MultiOptMsProp({
    required super.propName,
    super.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  }) : super._(singleSelection: true, children: const []);

  @override
  List<V>? get currentValue => _currentValue;

  @override
  List<V>? get initialValue => _initialValue;
}
