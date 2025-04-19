part of '../flutter_artist.dart';

abstract class Criterion {
  final String criterionName;

  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  //

  dynamic _tempCurrentValue;
  XData? _tempCurrentXData;

  dynamic _tempInitialValue;
  XData? _tempInitialXData;

  dynamic _currentValue;
  XData? _currentXData;

  dynamic _initialValue;
  XData? _initialXData;

  //

  Criterion({required this.criterionName});

  bool isDirty() {
    return !_compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
