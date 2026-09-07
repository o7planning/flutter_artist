part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
class _ScalarClearExecutionUnit<
        ID extends Comparable, //
        VALUE extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<ScalarClearResult> {
  final XScalar xScalar;

  @override
  final ScalarClearIntent<ID, VALUE> executionIntent;

  _ScalarClearExecutionUnit({
    required this.xScalar,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.scalarClear,
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
