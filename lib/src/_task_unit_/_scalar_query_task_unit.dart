part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_ScalarQueryAnnotation()
class _ScalarQueryTaskUnit extends _TaskUnit<ScalarQueryResult> {
  _XScalar xScalar;

  _ScalarQueryTaskUnit({
    required this.xScalar,
  }) : super(
          taskType: TaskType.scalarQuery,
          taskResult: ScalarQueryResult(precheck: null),
        );

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
