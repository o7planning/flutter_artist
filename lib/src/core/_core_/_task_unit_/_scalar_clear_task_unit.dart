part of '../core.dart';

@_TaskUnitClassAnnotation()
class _ScalarClearTaskUnit
    extends _ResultedSTaskUnit<ScalarClearResult> {
  final XScalar xScalar;

  _ScalarClearTaskUnit({
    required this.xScalar,
  }) : super(
          taskType: TaskType.scalarClear,
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
