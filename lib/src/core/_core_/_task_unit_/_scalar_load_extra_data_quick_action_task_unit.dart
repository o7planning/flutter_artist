part of '../core.dart';

@_TaskUnitClassAnnotation()
@_ScalarLoadExtraDataQuickActionAnnotation()
class _ScalarLoadExtraDataQuickActionTaskUnit<DATA extends Object>
    extends _STaskUnit {
  final XScalar xScalar;
  final ScalarQuickExtraDataLoadAction<DATA> action;
  final AfterScalarLoadExtraDataQuickAction afterQuickAction;

  _ScalarLoadExtraDataQuickActionTaskUnit({
    required this.xScalar,
    required this.action,
    required this.afterQuickAction,
  }) : super(taskType: TaskType.scalarLoadExtraData);

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
