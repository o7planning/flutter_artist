part of '../core.dart';

abstract class Criterion<V> {
  late final FilterCriteriaStructure _structure;

  //

  final String criterionName;

  V? candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  //

  V? _tempCurrentValue;
  XData? _tempCurrentXData;

  V? _tempInitialValue;
  XData? _tempInitialXData;

  V? _currentValue;
  XData? _currentXData;

  V? _initialValue;
  XData? _initialXData;

  //

  XData? get currentXData => _currentXData;

  V? get currentValue => _currentValue;

  V? get initialValue => _initialValue;

  XData? get initialXData => _initialXData;

  Criterion({required this.criterionName});

  bool isDirty() {
    return !ComparisonUtils.compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
