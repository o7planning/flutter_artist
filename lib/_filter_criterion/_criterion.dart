part of '../flutter_artist.dart';

abstract class Criterion {
  final String propName;
  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _dirty = false;

  Criterion({required this.propName});

  void _resetForNewTransaction();

  void _applyTempDataToReal();
}
