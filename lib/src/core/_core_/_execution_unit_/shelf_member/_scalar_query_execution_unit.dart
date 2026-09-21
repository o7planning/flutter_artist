part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_ScalarQueryAnnotation()
class _ScalarQueryExecutionUnit<
    ID extends Comparable, //
    VALUE extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XScalar xScalar;

  @override
  final ScalarQueryIntent<ID, VALUE> executionIntent;

  _ScalarQueryExecutionUnit({
    required this.xScalar,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.scalarQuery,
          executionIntent: executionIntent,
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
