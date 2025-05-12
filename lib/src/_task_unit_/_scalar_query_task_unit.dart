part of '../../flutter_artist.dart';

class _ScalarQueryTaskUnit extends _TaskUnit {
  _XScalar xScalar;

  _ScalarQueryTaskUnit({
    required this.xScalar,
  }) : super(taskType: TaskType.scalarQuery);

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
