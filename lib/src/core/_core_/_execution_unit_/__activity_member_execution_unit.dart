part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_ActivityAnnotation()
class _ActivityMemberExecutionUnit extends _ExecutionUnit {
  final XActivityV1 xActivity;

  _ActivityMemberExecutionUnit({
    required this.xActivity,
    required super.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.activity,
        );

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
