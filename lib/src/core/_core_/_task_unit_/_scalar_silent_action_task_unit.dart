part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ScalarSilentActionAnnotation()
class _ScalarSilentActionTaskUnit
    extends _ResultedTaskUnit<ScalarSilentActionResult> {
  final XScalar xScalar;
  final ScalarSilentAction action;

  _ScalarSilentActionTaskUnit({
    required this.xScalar,
    required this.action,
  }) : super(
          taskType: TaskType.scalarSilentAction,
          taskResult: ScalarSilentActionResult(),
        );

  @override
  XShelf get xShelf => xScalar.xShelf;

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
