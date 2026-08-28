part of '../core.dart';

@_ExecutionUnitClassAnnotation()
abstract class _ExecutionUnit {
  final ExecutionUnitType executionUnitType;

  Object get owner;

  _ExecutionUnit({required this.executionUnitType});

  String getObjectName();

  String asDebugExecutionUnit() {
    return executionUnitType.asDebugExecutionUnit(getObjectName());
  }
}

@_ExecutionUnitClassAnnotation()
abstract class _SExecutionUnit extends _ExecutionUnit {
  _SExecutionUnit({
    required super.executionUnitType,
  });

  String getExecutionUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  XShelf get xShelf;

  int get xShelfId;

  String getObjectName();

  Shelf get shelf;

  DebugExecutionUnit toDebugExecutionUnit() {
    return DebugExecutionUnit(
      executionUnitType: executionUnitType,
      taskName: getObjectName(),
    );
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
