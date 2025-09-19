part of '../core.dart';

abstract class Criterion<V> {
  late final FilterCriteriaStructure _structure;

  //

  final String criterionName;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  //
  // IMPORTANT: Do not change type (dynamic).
  dynamic _tempCurrentValue;
  XData? _tempCurrentXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _tempInitialValue;
  XData? _tempInitialXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _currentValue;
  XData? _currentXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _initialValue;
  XData? _initialXData;

  //

  XData? get currentXData => _currentXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic get currentValue => _currentValue;

  XData? get initialXData => _initialXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic get initialValue => _initialValue;

  Type get dataType => V;

  Criterion({required this.criterionName});

  bool isDirty() {
    return !ComparisonUtils.compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
