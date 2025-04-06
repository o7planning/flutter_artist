part of '../flutter_artist.dart';

abstract class Prop {
  final String propName;
  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _dirty = false;

  dynamic _currentValue;
  dynamic _currentData;

  dynamic _initialValue;
  dynamic _initialData;

  Prop({required this.propName,});

  void _resetForNewTransaction();

  void _applyTempDataToReal();
}
