part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
class _ScalarClearExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<ScalarClearResult> {
  final XScalar xScalar;

  _ScalarClearExecutionUnit({
    required this.xScalar,
  }) : super(
          executionUnitType: ExecutionUnitType.scalarClear,
          taskResult: ScalarClearResult(
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
