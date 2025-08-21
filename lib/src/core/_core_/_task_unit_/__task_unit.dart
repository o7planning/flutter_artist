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

  _XShelf get xShelf;

  int get xShelfId;

  String getObjectName();

  Shelf get shelf;

  Object get owner;

  DebugTaskUnit toDebugTaskUnit() {
    return DebugTaskUnit(xShelfId: xShelfId, shelf: shelf);
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
