part of '../core.dart';

@_ExecutionUnitClassAnnotation()
abstract class _ShelfMemberResultedExecutionUnit<RESULT>
    extends _ShelfMemberExecutionUnit {
  final RESULT executionUnitResult;

  _ShelfMemberResultedExecutionUnit({
    required super.executionUnitType,
    required this.executionUnitResult,
  });
}
