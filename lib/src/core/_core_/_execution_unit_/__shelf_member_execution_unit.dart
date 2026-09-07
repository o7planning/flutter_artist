part of '../core.dart';

@_ExecutionUnitClassAnnotation()
abstract class _ShelfMemberExecutionUnit extends _ExecutionUnit {
  _ShelfMemberExecutionUnit({
    required super.executionUnitType,
    required super.executionIntent,
  });

  String getExecutionUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  XShelf get xShelf;

  int get xShelfId;

  Shelf get shelf;

  DebugExecutionUnit toDebugExecutionUnit() {
    return DebugExecutionUnit(
      executionUnitType: executionUnitType,
      executionUnitName: getObjectName(),
    );
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
