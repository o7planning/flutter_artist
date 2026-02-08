part of '../../core.dart';

abstract class TildeFilterCriterionModel<V> {
  late final FilterModelStructure _structure;

  //
  final String criterionName;
  final String tildeCriterionName;
  final String tildeSuffix;

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

  TildeFilterCriterionModel({
    required this.tildeCriterionName,
    required this.criterionName,
    required this.tildeSuffix,
  });

  bool isDirty() {
    return !ComparisonUtils.compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
