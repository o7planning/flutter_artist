part of '../../core.dart';

class XActivity extends XRootQueueItem {
  final Activity activity;

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
  XActivity._({
    required this.activity,
  });

  _TaskUnit? _getNextTaskUnit() {
    if (_tasked) {
      return null;
    }
    _tasked = true;
    return _ActivityTaskUnit(xActivity: this);
  }

  @override
  bool isEmptyTask() {
    return _tasked;
  }

  @override
  DebugXRootQueueItem toDebugXRootQueueItem() {
    // TODO: implement toDebugXRootQueueItem
    throw UnimplementedError();
  }
}
