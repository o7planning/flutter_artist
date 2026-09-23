part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_ActivityAnnotation()
class _ActivityV1MemberExecutionUnit extends _ExecutionUnit {
  final XActivityV1 xActivityV1;

  _ActivityV1MemberExecutionUnit({
    required this.xActivityV1,
    required super.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.activity,
        );

  @override
  ActivityV1 get owner => xActivityV1.activityV1;

  @override
  String getObjectName() {
    return getClassName(xActivityV1.activityV1);
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(xActivityV1.activityV1)})";
  }
}
