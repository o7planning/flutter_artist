part of '../core.dart';

abstract class _TaskUnitBase {
  //
}

@_TaskUnitClassAnnotation()
abstract class _TaskUnit extends _TaskUnitBase {
  final TaskType taskType;

  _TaskUnit({
    required this.taskType,
  });

  String getTaskUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  XShelf get xShelf;

  int get xShelfId;

  String getObjectName();

  Shelf get shelf;

  Object get owner;

  DebugTaskUnit toDebugTaskUnit() {
    return DebugTaskUnit(
      taskType: taskType,
      taskName: getObjectName(),
    );
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
