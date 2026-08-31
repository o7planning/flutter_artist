part of '../core.dart';

@_ExecutionUnitClassAnnotation()
abstract class _ShelfMemberResultedExecutionUnit<RESULT>
    extends _ShelfMemberExecutionUnit {
  final RESULT executionUnitResult;

  ExecutionTodo? get executionTodo;

  _ShelfMemberResultedExecutionUnit({
    required super.executionUnitType,
    required this.executionUnitResult,
  });
}
