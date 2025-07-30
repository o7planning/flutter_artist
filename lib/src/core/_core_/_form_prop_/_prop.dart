part of '../core.dart';

abstract class Prop<V> {
  late final FormPropsStructure _structure;

  //
  final String propName;
  V? _candidateUpdateValue;
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

  // @NEW-TODO
  V? get initialValue => _initialValue;

  XData? get initialXData => _initialXData;

  V? get currentValue => _currentValue;

  XData? get currentXData => _currentXData;

  // ------------ Error: -------------------------------------------------------

  FormErrorInfo? _formErrorInfo;

  FormErrorInfo? get formErrorInfo => _formErrorInfo;

  // ---------------------------------------------------------------------------

  Prop({
    required this.propName,
  });

  bool isDirty() {
    return !ComparisonUtils.compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
