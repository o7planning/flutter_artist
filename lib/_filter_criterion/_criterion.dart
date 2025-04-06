part of '../flutter_artist.dart';

abstract class Criterion {
  final String criterionName;
  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;
  
  //


  dynamic _tempCurrentValue;
  XOptionedData? _tempCurrentXData;

  dynamic _currentValue;
  XOptionedData? _currentXData;

  dynamic _initialValue;
  XOptionedData? _initialXData;

  //
  

  Criterion({required this.criterionName});

  void _resetForNewTransaction();

  void _applyTempDataToReal();
}
