part of '../flutter_artist.dart';

abstract class Criterion {
  final String criterionName;
  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _dirty = false;

  Criterion({required this.criterionName});

  void _resetForNewTransaction();

  void _applyTempDataToReal();
}
