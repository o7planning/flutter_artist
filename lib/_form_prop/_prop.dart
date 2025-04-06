part of '../flutter_artist.dart';

abstract class Prop {
  final String propName;
  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  dynamic _tempCurrentValue;
  XOptionedData? _tempCurrentXData;

  dynamic _currentValue;
  XOptionedData? _currentXData;

  dynamic _initialValue;
  XOptionedData? _initialXData;

  Prop({
    required this.propName,
  });

  bool isDirty() {
    return !_compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
