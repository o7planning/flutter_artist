part of '../core.dart';

@_TaskUnitClassAnnotation()
class _ScalarClearanceTaskUnit
    extends _ResultedSTaskUnit<ScalarClearanceResult> {
  final XScalar xScalar;

  _ScalarClearanceTaskUnit({
    required this.xScalar,
  }) : super(
    taskType: TaskType.scalarClearance,
    taskResult: ScalarClearanceResult(
      precheck: null,
    ),
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
