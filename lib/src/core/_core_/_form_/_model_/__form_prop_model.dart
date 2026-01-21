part of '../../core.dart';

abstract class FormPropModel<V> {
  late final FormModelStructure _structure;

  //
  final String propName;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  //
  Type get dataType => V;

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

  // IMPORTANT: Do not change type (dynamic).
  dynamic get initialValue => _initialValue;

  XData? get initialXData => _initialXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic get currentValue => _currentValue;

  XData? get currentXData => _currentXData;

  // ------------ Error: -------------------------------------------------------

  FormErrorInfo? _formErrorInfo;

  FormErrorInfo? get formErrorInfo => _formErrorInfo;

  // ---------------------------------------------------------------------------

  FormPropModel({
    required this.propName,
  });

  bool isDirty() {
    return !ComparisonUtils.compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
