part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ActivityAnnotation()
class _ActivityTaskUnit extends _TaskUnit {
  XActivity xActivity;

  _ActivityTaskUnit({
    required this.xActivity,
  }) : super(taskType: TaskType.activity);

  @override
  Activity get owner => xActivity.activity;

  @override
  String getObjectName() {
    return getClassName(xActivity.activity);
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(xActivity.activity)})";
  }
}
