part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_ScalarQueryAnnotation()
class _ScalarQueryExecutionUnit extends _ShelfMemberExecutionUnit {
  XScalar xScalar;

  _ScalarQueryExecutionUnit({
    required this.xScalar,
  }) : super(
          executionUnitType: ExecutionUnitType.scalarQuery,
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
