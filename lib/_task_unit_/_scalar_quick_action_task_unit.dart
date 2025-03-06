part of '../flutter_artist.dart';

class _ScalarQuickActionTaskUnit<DATA extends Object> extends _TaskUnit {
  final _XScalar xScalar;
  final QuickAction<DATA> action;
  final AfterScalarQuickAction afterQuickAction;

  _ScalarQuickActionTaskUnit({
    required this.xScalar,
    required this.action,
    required this.afterQuickAction,
  });

  @override
  String getObjectName() {
    return xScalar.scalar.name;
  }
}
