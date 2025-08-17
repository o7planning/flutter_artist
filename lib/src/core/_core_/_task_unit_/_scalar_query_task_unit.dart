part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ScalarQueryAnnotation()
class _ScalarQueryTaskUnit extends _TaskUnit {
  _QScalar xScalar;

  _ScalarQueryTaskUnit({
    required this.xScalar,
  }) : super(
          taskType: TaskType.scalarQuery,
        );



  @override
  _QShelf get xShelf => xScalar.xShelf;



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
