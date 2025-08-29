part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ScalarQueryAnnotation()
class _ScalarQueryTaskUnit extends _STaskUnit {
  XScalar xScalar;

  _ScalarQueryTaskUnit({
    required this.xScalar,
  }) : super(
          taskType: TaskType.scalarQuery,
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
