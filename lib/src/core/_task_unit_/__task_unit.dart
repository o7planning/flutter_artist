part of '../_fa_core.dart';

@_TaskUnitClassAnnotation()
abstract class _TaskUnit {
  final TaskType taskType;

  _TaskUnit({
    required this.taskType,
  });

  String getTaskUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  int get xShelfId;

  String getObjectName();

  Shelf get shelf;

  Object get owner;

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
