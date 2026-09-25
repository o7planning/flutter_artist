part of '../core.dart';

class _DeskCore extends _DeskCoreV1 {
  final Map<String, ActivityCreator> __activityCreatorMap = {};
  final Map<String, Activity> _activityMap = {};

  final List<Activity> _recentActivities = [];

  List<String> get activeActivityNames => List.unmodifiable(_activityMap.keys);

  List<Activity> get activeActivities => List.unmodifiable(_activityMap.values);

  // ***************************************************************************
  // ***************************************************************************

  String _getActivityName(Type type) {
    return type.toString();
  }

  @DebugMethodAnnotation()
  String debugGetActivityName(Type type) {
    return _getActivityName(type);
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerActivity<F extends Activity>(ActivityCreator<F> builder) {
    if (FlutterArtist._navigatorStated) {
      // LOGIC: #0001
      throw DebugUtils.getFatalError(
        " ERROR: It is not possible to register a new Activity after the application has been started.",
      );
    }
    //
    final String activityName = _getActivityName(F);
    FlutterArtist.debugRegister
        ._addDebugRegisterActivity("<b>$activityName</b>.");
    //
    ActivityCreator? creator = __activityCreatorMap[activityName];
    if (creator == null) {
      __activityCreatorMap[activityName] = builder;
    }
    _createActivity(activityName);
  }

  F _createActivity<F extends Activity>(String activityName) {
    F? activity = _activityMap[activityName] as F?;
    if (activity != null) {
      return activity;
    }
    if (!FlutterArtist._navigatorStated) {
      // Nothing.
    }

    ActivityCreator? creator = __activityCreatorMap[activityName];
    if (creator == null) {
      throw DebugUtils.getFatalError(
          " ERROR: '$activityName' not found. You need to call:\n "
          " FlutterArtist.storage.registerActivity(()=> $activityName())");
    }
    activity = creator() as F;
    if (FlutterArtist._navigatorStated) {
      _activityMap[activityName] = activity;
    }
    //
    return activity;
  }

  Activity? _findActivity(Type activityType) {
    final String activityName = _getActivityName(activityType);
    Activity? activity = _activityMap[activityName];
    activity ??= _createActivity(activityName);
    return activity;
  }

  F findActivity<F extends Activity>() {
    final String activityName = _getActivityName(F);
    Activity? activity = _activityMap[activityName];
    activity ??= _createActivity(activityName);
    return activity as F;
  }

  F? findActivityOrNull<F extends Activity>() {
    final String activityName = _getActivityName(F);
    F? activity = _activityMap[activityName] as F?;
    return activity;
  }

  void __clearActivities() {
    _recentActivities.clear();
    __activityCreatorMap.clear();
    _activityMap.clear();
  }

  void _checkToRemoveActivity(Activity activity) {
    bool hasMountedUiComponent = activity.ui.hasMountedViews();
    if (!hasMountedUiComponent) {
      switch (activity.config.releasePolicy) {
        case ActivityReleasePolicy.retain:
          print(
              "[FLUTTER_ARTIST] ---------> RETAIN_IN_MEMORY: ${getClassName(activity)}");
          return;
        case ActivityReleasePolicy.unmount:
          print(
              "[FLUTTER_ARTIST] ---------> MARK_TO_RELEASE_AND_PRUNE: ${getClassName(activity)} - ${DateTime.now()}");
          activity._markAsOrphaned(true);
          return;
      }
    } else {
      print(
          "[FLUTTER_ARTIST] ---------> SET ORPHANED FALSE: ${getClassName(activity)} - ${DateTime.now()}");
      activity._markAsOrphaned(false);
    }
  }

  void _addRecentActivity(Activity activity) {
    //
  }
}
