part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ScalarQuickActionAnnotation()
class _ScalarQuickActionTaskUnit
    extends _ResultedTaskUnit<ScalarQuickActionResult> {
  final _XScalar xScalar;
  final ScalarQuickAction action;

  _ScalarQuickActionTaskUnit({
    required this.xScalar,
    required this.action,
  }) : super(
          taskType: TaskType.scalarQuickAction,
          taskResult: ScalarQuickActionResult(),
        );

  @override
  int get xShelfId => xScalar.xShelfId;

  @override
  Shelf get shelf => xScalar.scalar.shelf;

  @override
  Scalar get owner => xScalar.scalar;

  @override
  String getObjectName() {
    return xScalar.scalar.name;
  }
}
