part of '../core.dart';

@_TaskUnitClassAnnotation()
abstract class _TaskUnit {
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
      xShelf: xShelf,
      taskType: taskType,
      taskName: getObjectName(),
    );
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
