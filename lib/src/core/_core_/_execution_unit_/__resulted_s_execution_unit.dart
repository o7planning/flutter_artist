part of '../core.dart';

@_ExecutionUnitClassAnnotation()
abstract class _ResultedSExecutionUnit<RESULT> extends _SExecutionUnit {
  final RESULT taskResult;

  _ResultedSExecutionUnit({
    required super.executionUnitType,
    required this.taskResult,
  });
}
