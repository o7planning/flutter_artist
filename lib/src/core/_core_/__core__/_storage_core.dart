part of '../core.dart';

typedef ShelfCreator<S> = S Function();
typedef ActivityCreator<S> = S Function();

abstract class _StorageCore extends _Core {
  final Map<String, ShelfCreator> __shelfCreatorMap = {};
  final Map<String, ActivityCreator> __activityCreatorMap = {};

  final Map<String, Shelf> _shelfMap = {};
  final Map<String, Activity> _activityMap = {};

  final List<Shelf> _recentShelves = [];
  final List<Activity> _recentActivities = [];

  bool __started = false;

  bool get started => __started;

  // Map<String, Shelf?> get shelfMap {
  //   Map<String, Shelf?> m = __shelfCreatorMap
  //       .map((k, v) => MapEntry<String, Shelf?>(k, null))
  //     ..addAll(_shelfMap);
  //   return m;
  // }

  // Map<String, Activity?> get activityMap {
  //   Map<String, Activity?> m = __activityCreatorMap
  //       .map((k, v) => MapEntry<String, Activity?>(k, null))
  //     ..addAll(_activityMap);
  //   return m;
  // }

  List<String> get activeShelfNames => List.unmodifiable(_shelfMap.keys);

  List<Shelf> get activeShelves => List.unmodifiable(_shelfMap.values);

  List<String> get activeActivityNames => List.unmodifiable(_activityMap.keys);

  List<Activity> get activeActivities => List.unmodifiable(_activityMap.values);

  // ***************************************************************************
  // ***************************************************************************

  _StorageCore();

  // ***************************************************************************
  // ***************************************************************************

  void _setStarted() {
    if (!__started) {
      __started = true;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? findShelfByName(String shelfName) {
    return _shelfMap[shelfName];
  }

  List<Shelf> getAllShelves() {
    return List.unmodifiable(_shelfMap.values);
  }

  // ***************************************************************************
  // ***************************************************************************

  String _getAutoStockerName(Type type) {
    return type.toString();
  }

  String _getShelfName(Type type) {
    return type.toString();
  }

  String _getActivityName(Type type) {
    return type.toString();
  }

  @DebugMethodAnnotation()
  String debugGetShelfName(Type type) {
    return _getShelfName(type);
  }

  @DebugMethodAnnotation()
  String debugGetActivityName(Type type) {
    return _getActivityName(type);
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerActivity<F extends Activity>(ActivityCreator<F> builder) {
    if (__started) {
      // LOGIC: #0001
      throw DebugUtils.getFatalError(
        " ERROR: It is not possible to register a new Activity after the application has been started.",
      );
    }
    //
    final String activityName = _getActivityName(F);
    FlutterArtist.debugRegister._addDebugRegisterActivity(
        "<b>FlutterArtist.storage.registerActivity()</b> for <b>$activityName</b>.");
    //
    ActivityCreator? creator = __activityCreatorMap[activityName];
    if (creator == null) {
      __activityCreatorMap[activityName] = builder;
    }
    _createActivity(activityName);
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerShelf<F extends Shelf>(ShelfCreator<F> builder) {
    if (__started) {
      // LOGIC: #0001
      throw DebugUtils.getFatalError(
        " ERROR: It is not possible to register a new Shelf after the application has been started.",
      );
    }
    //
    final String shelfName = _getShelfName(F);
    FlutterArtist.debugRegister._addDebugRegisterShelf(
        "<b>FlutterArtist.storage.registerShelf()</b> for <b>$shelfName</b>.");
    //
    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      __shelfCreatorMap[shelfName] = builder;
    }
    _createShelf(shelfName);
  }

  // ***************************************************************************
  // ***************************************************************************

  F _createShelf<F extends Shelf>(String shelfName) {
    F? shelf = _shelfMap[shelfName] as F?;
    if (shelf != null) {
      return shelf;
    }
    if (!__started) {
      // Nothing.
    }

    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw DebugUtils.getFatalError(
          " ERROR: '$shelfName' not found. You need to call:\n "
          " FlutterArtist.storage.registerShelf(()=> $shelfName())");
    }
    shelf = creator() as F;
    if (__started) {
      _shelfMap[shelfName] = shelf;
    }
    //
    return shelf;
  }

  F _createActivity<F extends Activity>(String activityName) {
    F? activity = _activityMap[activityName] as F?;
    if (activity != null) {
      return activity;
    }
    if (!__started) {
      // Nothing.
    }

    ActivityCreator? creator = __activityCreatorMap[activityName];
    if (creator == null) {
      throw DebugUtils.getFatalError(
          " ERROR: '$activityName' not found. You need to call:\n "
          " FlutterArtist.storage.registerActivity(()=> $activityName())");
    }
    activity = creator() as F;
    if (__started) {
      _activityMap[activityName] = activity;
    }
    //
    return activity;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __loadAllShelves() {
    for (String shelfName in __shelfCreatorMap.keys) {
      _createShelf(shelfName);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? _findShelf(Type shelfType) {
    final String shelfName = _getShelfName(shelfType);
    Shelf? shelf = _shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf;
  }

  Activity? _findActivity(Type activityType) {
    final String activityName = _getActivityName(activityType);
    Activity? activity = _activityMap[activityName];
    activity ??= _createActivity(activityName);
    return activity;
  }

  // TODO: Internal Use.
  @DebugMethodAnnotation()
  Shelf? debugFindShelf(Type shelfType) {
    return _findShelf(shelfType);
  }

  // ***************************************************************************
  // ***************************************************************************

  F findShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    Shelf? shelf = _shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf as F;
  }

  F findActivity<F extends Activity>() {
    final String activityName = _getActivityName(F);
    Activity? activity = _activityMap[activityName];
    activity ??= _createActivity(activityName);
    return activity as F;
  }

  // ***************************************************************************
  // ***************************************************************************

  F? findOrNullShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    F? shelf = _shelfMap[shelfName] as F?;
    return shelf;
  }

  F? findOrNullActivity<F extends Activity>() {
    final String activityName = _getActivityName(F);
    F? activity = _activityMap[activityName] as F?;
    return activity;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Very Dangerous!!! Only call on startup.
  ///
  void __clear() {
    __clearShelves();
    __clearActivities();
  }

  void __clearShelves() {
    _recentShelves.clear();
    __shelfCreatorMap.clear();
    _shelfMap.clear();
  }

  void __clearActivities() {
    _recentActivities.clear();
    __activityCreatorMap.clear();
    _activityMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _resetForTestOnly() {
    _shelfMap.clear();
  }

  // // TODO: Internal Use.
  // @DebugMethodAnnotation()
  // void debugLoadAll() {
  //   __loadAllShelves();
  // }

  // // TODO: Internal Use.
  // @DebugMethodAnnotation()
  // F debugCreateShelf<F extends Shelf>(String shelfName) {
  //   return _createShelf(shelfName);
  // }

  // ***************************************************************************
  // ***************************************************************************

  void _checkToRemoveActivity(Activity activity) {
    //
  }

  void _checkToRemoveShelf(Shelf shelf) {
    bool hasMountedUIComponent = shelf.ui.hasMountedUIComponent();
    if (!hasMountedUIComponent) {
      print(">>>>>>>>>>> Shelf: ${getClassName(shelf)} dispose all component");
      // FlutterArtist.codeFlowLogger.addInfo(
      //   ownerClassInstance: this,
      //   info: "Shelf: ${getClassName(shelf)} dispose all UI components",
      // );
      if (shelf.config.hiddenBehavior == ShelfHiddenBehavior.clear) {
        print(
            "  ---------> Remove ${getClassName(shelf)} from FlutterArtist Storage");
        _shelfMap.remove(shelf.name);
      } else {
        print("  ---------> Do Nothing");
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? _recentShelf() {
    return _recentShelves.isEmpty ? null : _recentShelves.first;
  }

  List<Shelf> getRecentShelves({required bool visibleOnly}) {
    List<Shelf> ret = [];
    for (Shelf shelf in _recentShelves) {
      if (shelf.disposed) {
        continue;
      }
      if (visibleOnly) {
        if (!shelf.ui.hasMountedUIComponent()) {
          continue;
        }
      }
      ret.add(shelf);
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addRecentActivity(Activity activity) {
    //
  }

  void _addRecentShelf(Shelf shelf) {
    if (_recentShelves.isEmpty) {
      _recentShelves.add(shelf);
    } else {
      if (_recentShelves.first == shelf) {
        return;
      } else {
        int idx = _recentShelves.indexOf(shelf);
        if (idx == -1) {
          _recentShelves.insert(0, shelf);
        } else {
          var temp = _recentShelves[0];
          _recentShelves[0] = _recentShelves[idx];
          _recentShelves[idx] = temp;
        }
      }
    }
  }
}
