part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_ActivityAnnotation()
class _ActivityExecutionUnit extends _ExecutionUnit {
  XActivityV1 xActivity;

  _ActivityExecutionUnit({
    required this.xActivity,
  }) : super(executionUnitType: ExecutionUnitType.activity);

  @override
  ActivityV1 get owner => xActivity.activity;

  @override
  String getObjectName() {
    return getClassName(xActivity.activity);
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(xActivity.activity)})";
  }
}
