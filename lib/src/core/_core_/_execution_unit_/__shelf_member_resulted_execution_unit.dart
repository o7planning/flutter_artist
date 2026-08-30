part of '../core.dart';

@_ExecutionUnitClassAnnotation()
abstract class _ShelfMemberResultedExecutionUnit<RESULT>
    extends _ShelfMemberExecutionUnit {
  final RESULT taskResult;

  _ShelfMemberResultedExecutionUnit({
    required super.executionUnitType,
    required this.taskResult,
  });
}
