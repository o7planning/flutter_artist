part of '../core.dart';

@_TaskUnitClassAnnotation()
abstract class _TaskUnit {
  Object get owner;
}

@_TaskUnitClassAnnotation()
abstract class _STaskUnit extends _TaskUnit {
  final TaskType taskType;

  _STaskUnit({
    required this.taskType,
  });

  String getTaskUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  XShelf get xShelf;

  int get xShelfId;

  String getObjectName();

  Shelf get shelf;

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
