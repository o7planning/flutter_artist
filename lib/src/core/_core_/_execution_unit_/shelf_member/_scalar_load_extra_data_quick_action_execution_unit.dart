part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_ScalarLoadExtraDataQuickActionAnnotation()
class _ScalarLoadExtraDataQuickActionExecutionUnit<
    ID extends Comparable, //
    VALUE extends Identifiable<ID>,
    DATA extends Object> extends _ShelfMemberExecutionUnit {
  final XScalar xScalar;

  @override
  final ScalarLoadExtraDataQuickActionIntent<ID, VALUE, DATA> executionIntent;

  _ScalarLoadExtraDataQuickActionExecutionUnit({
    required this.xScalar,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.scalarLoadExtraData,
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
