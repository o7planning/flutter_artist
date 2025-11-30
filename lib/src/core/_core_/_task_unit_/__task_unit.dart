part of '../core.dart';

@_TaskUnitClassAnnotation()
abstract class _TaskUnit {
  final TaskType taskType;

  Object get owner;

  _TaskUnit({required this.taskType});

  String getObjectName();

  String asDebugTaskUnit() {
    return taskType.asDebugTaskUnit(getObjectName());
  }
}

@_TaskUnitClassAnnotation()
abstract class _STaskUnit extends _TaskUnit {
  _STaskUnit({
    required super.taskType,
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
