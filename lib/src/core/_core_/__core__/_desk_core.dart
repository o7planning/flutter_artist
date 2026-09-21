part of '../core.dart';

class _DeskCore extends _Core {
  final Map<String, ActivityCreator> __activityCreatorMap = {};
  final Map<String, ActivityV1> _activityMap = {};

  final List<ActivityV1> _recentActivities = [];

  List<String> get activeActivityNames => List.unmodifiable(_activityMap.keys);

  List<ActivityV1> get activeActivities =>
      List.unmodifiable(_activityMap.values);

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

  void registerActivity<F extends ActivityV1>(ActivityCreator<F> builder) {
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

  F _createActivity<F extends ActivityV1>(String activityName) {
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

  ActivityV1? _findActivity(Type activityType) {
    final String activityName = _getActivityName(activityType);
    ActivityV1? activity = _activityMap[activityName];
    activity ??= _createActivity(activityName);
    return activity;
  }

  F findActivity<F extends ActivityV1>() {
    final String activityName = _getActivityName(F);
    ActivityV1? activity = _activityMap[activityName];
    activity ??= _createActivity(activityName);
    return activity as F;
  }

  F? findActivityOrNull<F extends ActivityV1>() {
    final String activityName = _getActivityName(F);
    F? activity = _activityMap[activityName] as F?;
    return activity;
  }

  void __clearActivities() {
    _recentActivities.clear();
    __activityCreatorMap.clear();
    _activityMap.clear();
  }

  void _checkToRemoveActivity(ActivityV1 activity) {
    //
  }

  void _addRecentActivity(ActivityV1 activity) {
    //
  }
}
