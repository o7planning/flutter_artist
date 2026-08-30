part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_ScalarLoadExtraDataQuickActionAnnotation()
class _ScalarLoadExtraDataQuickActionExecutionUnit<DATA extends Object>
    extends _ShelfMemberExecutionUnit {
  final XScalar xScalar;
  final ScalarQuickExtraDataLoadAction<DATA> action;
  final AfterScalarLoadExtraDataQuickAction afterQuickAction;

  _ScalarLoadExtraDataQuickActionExecutionUnit({
    required this.xScalar,
    required this.action,
    required this.afterQuickAction,
  }) : super(executionUnitType: ExecutionUnitType.scalarLoadExtraData);

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
