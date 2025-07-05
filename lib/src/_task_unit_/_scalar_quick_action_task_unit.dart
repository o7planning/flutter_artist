part of '../../flutter_artist.dart';

@_ScalarExecuteQuickActionAnnotation()
class _ScalarQuickActionTaskUnit<DATA extends Object> extends _TaskUnit {
  final _XScalar xScalar;
  final QuickAction<DATA> action;
  final AfterScalarQuickAction afterQuickAction;

  _ScalarQuickActionTaskUnit({
    required this.xScalar,
    required this.action,
    required this.afterQuickAction,
  }) : super(taskType: TaskType.scalarQuickAction);

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
