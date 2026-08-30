part of '../core.dart';

class XActivityV1 extends XRootQueueItem {
  final ActivityV1 activity;

  // String get name => activity.name;

  @override
  String get _fullName => "@XActivity-${getClassName(activity)}";

  bool _tasked = false;

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// IMPORTANT: To create new XActivity, use 'activity._createXActivity' method
  /// to have the same Generics Parameters with the activity.
  ///
  XActivityV1._({
    required this.activity,
  });

  _ExecutionUnit? _getNextExecutionUnit() {
    if (_tasked) {
      return null;
    }
    _tasked = true;
    return _ActivityMemberExecutionUnit(xActivity: this);
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
