part of '../core.dart';

@_ExecutionUnitClassAnnotation()
abstract class _ActivityMemberExecutionUnit extends _ExecutionUnit {
  _ActivityMemberExecutionUnit({
    required super.executionUnitType,
    required super.executionIntent,
  });

  XActivity get xActivity;

  int get xActivityId;

  Activity get activity;

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
