part of '../core.dart';

typedef ActivityV1Creator<S> = S Function();

@Deprecated("Will be removed")
class _DeskCoreV1 extends _Core {
  final Map<String, ActivityV1Creator> __activityV1CreatorMap = {};
  final Map<String, ActivityV1> _activityV1Map = {};

  List<String> get activeActivityV1Names =>
      List.unmodifiable(_activityV1Map.keys);

  // ***************************************************************************
  // ***************************************************************************

  String _getActivityV1Name(Type type) {
    return type.toString();
  }

  @DebugMethodAnnotation()
  String debugGetActivityV1Name(Type type) {
    return _getActivityV1Name(type);
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerActivityV1<F extends ActivityV1>(ActivityV1Creator<F> builder) {
    if (FlutterArtist._navigatorStated) {
      // LOGIC: #0001
      throw DebugUtils.getFatalError(
        " ERROR: It is not possible to register a new Activity after the application has been started.",
      );
    }
    //
    final String activityV1Name = _getActivityV1Name(F);
    FlutterArtist.debugRegister
        ._addDebugRegisterActivity("<b>$activityV1Name</b>.");
    //
    ActivityV1Creator? creator = __activityV1CreatorMap[activityV1Name];
    if (creator == null) {
      __activityV1CreatorMap[activityV1Name] = builder;
    }
    _createActivityV1(activityV1Name);
  }

  F _createActivityV1<F extends ActivityV1>(String activityV1Name) {
    F? activity = _activityV1Map[activityV1Name] as F?;
    if (activity != null) {
      return activity;
    }
    if (!FlutterArtist._navigatorStated) {
      // Nothing.
    }

    ActivityV1Creator? creator = __activityV1CreatorMap[activityV1Name];
    if (creator == null) {
      throw DebugUtils.getFatalError(
          " ERROR: '$activityV1Name' not found. You need to call:\n "
              " FlutterArtist.storage.registerActivity(()=> $activityV1Name())");
    }
    activity = creator() as F;
    if (FlutterArtist._navigatorStated) {
      _activityV1Map[activityV1Name] = activity;
    }
    //
    return activity;
  }

  ActivityV1? _findActivityV1(Type activityType) {
    final String activityV1Name = _getActivityV1Name(activityType);
    ActivityV1? activity = _activityV1Map[activityV1Name];
    activity ??= _createActivityV1(activityV1Name);
    return activity;
  }

  F findActivityV1<F extends ActivityV1>() {
    final String activityV1Name = _getActivityV1Name(F);
    ActivityV1? activity = _activityV1Map[activityV1Name];
    activity ??= _createActivityV1(activityV1Name);
    return activity as F;
  }

  F? findActivityV1OrNull<F extends ActivityV1>() {
    final String activityV1Name = _getActivityV1Name(F);
    F? activity = _activityV1Map[activityV1Name] as F?;
    return activity;
  }

  void __clearActivitiesV1() {
    __activityV1CreatorMap.clear();
    _activityV1Map.clear();
  }

  void _checkToRemoveActivityV1(ActivityV1 activity) {
    //
  }

  void _addRecentActivityV1(Activity activity) {
    //
  }
}
