part of '../core.dart';

class XActivityV1 extends XRootQueueItem {
  final ActivityV1 activityV1;

  @override
  String get _fullName => "@XActivity-${getClassName(activityV1)}";

  bool _tasked = false;

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// IMPORTANT: To create new XActivity, use 'activity._createXActivity' method
  /// to have the same Generics Parameters with the activity.
  ///
  XActivityV1._({
    required this.activityV1,
  });

  NxtExecutionUnit? _getNextExecutionUnit({required bool debug}) {
    if (_tasked) {
      return null;
    }
    _tasked = true;
    return NxtExecutionUnit.yes(
      debug: debug,
      executionUnit: _DefaultActivityV1ExecutionUnit(
        xActivityV1: this,
        executionIntent: DefaultActivityV1ExecutionIntent(),
      ),
      info: '_getNextExecutionUnit',
    );
  }

  @override
  bool isEmptyExecutionUnit() {
    return _tasked;
  }

  @override
  DebugXRootQueueItem toDebugXRootQueueItem() {
    throw UnimplementedError("toDebugXRootQueueItem");
  }
}
