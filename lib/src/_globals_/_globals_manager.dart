part of '../../flutter_artist.dart';

class GlobalsManager {
  final String __separator = "\n";

  ///
  /// Hive Prefix Key for "Extra Prop Names", for example: {'language', 'theme'}.
  ///
  final String __prefixHiveExtraPropNamesKey = "@__hiveExtraPropNamesKey__@";

  ///
  /// Hive Prefix Key for "Extra Prop Name", for example: 'language'.
  ///
  final String __prefixHiveExtraPropNameKey = "@__hiveExtraPropNameKey__@";

  //
  final String __hiveKeyLoggedInUser =
      "---flutter-artist-hive-key-logged-in-user---";

  int _loadGlobalDataCount = 0;

  int get loadGlobalDataCount => _loadGlobalDataCount;

  IGlobalData? _globalData;

  ILoggedInUser? _loggedInUser;

  ILoggedInUser? get loggedInUser => _loggedInUser;

  IGlobalData? get globalData => _globalData;

  final Map<_RefreshableWidgetState, bool> _loggedInUserWidgetStates = {};

  final ILoggedInUserAdapter loggedInUserAdapter;

  final IGlobalDataAdapter globalDataAdapter;

  ///
  /// For example: {"language", "theme"}
  ///
  final Set<String> __registeredExtraPropNames = {};

  Set<String> get registeredExtraPropNames => {...__registeredExtraPropNames};

  final Map<String, dynamic> __extraPropMap = {};

  GlobalsManager._({
    required this.loggedInUserAdapter,
    required this.globalDataAdapter,
  });

  String __getHiveExtraGlobalPropNamesKey() {
    String key = __prefixHiveExtraPropNamesKey;
    if (_loggedInUser != null) {
      key = "$key-**-${_loggedInUser!.userName}";
    }
    return key;
  }

  String __getHiveExtraGlobalPropNameKey(String propName) {
    String key = __prefixHiveExtraPropNameKey;
    if (_loggedInUser != null) {
      key = "$key-**-$propName-**-${_loggedInUser!.userName}";
    }
    return key;
  }

  ///
  /// Extra Global Prop Names. For Example:
  /// - language
  /// - theme
  ///
  Future<void> __readExtraGlobalProps() async {
    _printDebugState(
        DebugCat.appStart, "  --- globalManager.__readExtraGlobalProps()...");
    // Store on local device:
    Box<String> hiveBox = await _HiveUtils.openHiveBoxExtraGlobalPropNames();
    try {
      String key = __getHiveExtraGlobalPropNamesKey();
      _printDebugState(DebugCat.appStart,
          "  --- globalManager.__readExtraGlobalProps(). key: $key");
      _printDebugState(
          DebugCat.appStart, "  --- __readExtraGlobalProps(). key: $key");
      String extraGlobalPropNames = hiveBox.get(key) ?? "";
      _printDebugState(DebugCat.appStart,
          "  --- __readExtraGlobalProps. extraGlobalPropNames: $extraGlobalPropNames");
      List<String> propNames = extraGlobalPropNames
          .split(__separator)
          .where((s) => s.isNotEmpty)
          .toList();

      _printDebugState(DebugCat.appStart,
          "  --- __readExtraGlobalProps. propNames: $propNames");
      //
      __registeredExtraPropNames
        ..clear()
        ..addAll(propNames);
    } catch (e, stackTrace) {
      print("Error __readExtraGlobalProps: $e");
      print(stackTrace);
      return;
    } finally {
      await hiveBox.close();
    }
    //
    for (String propName in __registeredExtraPropNames) {
      dynamic value = await __readExtraGlobalProp(propName);
      __extraPropMap[propName] = value;
      _printDebugState(DebugCat.appStart,
          "  --- __readExtraGlobalProps. propName: $propName --> $value");
    }
  }

  Future<bool> __storeExtraGlobalPropNames() async {
    _printDebugState(
        DebugCat.globalManager, "   --- __storeExtraGlobalPropNames()...");
    // Store on local device:
    Box<String> hiveBox = await _HiveUtils.openHiveBoxExtraGlobalPropNames();
    try {
      String key = __getHiveExtraGlobalPropNamesKey();
      String value = __registeredExtraPropNames.toList().join(__separator);
      _printDebugState(DebugCat.globalManager,
          "   --- __storeExtraGlobalPropNames(). key: $key");
      _printDebugState(DebugCat.globalManager,
          "   --- __storeExtraGlobalPropNames(). value: $value");
      await hiveBox.put(key, value);
      return true;
    } catch (e, stackTrace) {
      print("Error __storeExtraGlobalPropNames: $e");
      print(stackTrace);
      return false;
    } finally {
      await hiveBox.close();
    }
  }

  Future<dynamic> __readExtraGlobalProp(String propName) async {
    Box<dynamic> hiveBox = await _HiveUtils.openHiveBoxExtraGlobalProp();
    try {
      String key = __getHiveExtraGlobalPropNameKey(propName);
      dynamic value = hiveBox.get(key);
      return value;
    } finally {
      await hiveBox.close();
    }
  }

  dynamic getExtraGlobalProp(String propName) {
    return __extraPropMap[propName];
  }

  Future<void> storeExtraGlobalProp(String propName, dynamic value) async {
    _printDebugState(DebugCat.globalManager,
        "GlobalManager ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> storeExtraGlobalProp()...");
    __registeredExtraPropNames.add(propName);
    _printDebugState(DebugCat.globalManager, "   --- propName: $propName");
    _printDebugState(DebugCat.globalManager,
        "   --- __registeredExtraPropNames: $__registeredExtraPropNames");
    bool success = await __storeExtraGlobalPropNames();
    if (!success) {
      return;
    }
    //
    __extraPropMap[propName] = value;
    //
    Box<dynamic> hiveBox = await _HiveUtils.openHiveBoxExtraGlobalProp();
    String key = __getHiveExtraGlobalPropNameKey(propName);
    await hiveBox.put(key, value);
    await hiveBox.close();
    _printDebugState(
        DebugCat.globalManager, "   --- hiveBox.put: key: $key, value: $value");
  }

  ///
  /// This method is called only once when FlutterArtist is started.
  ///
  Future<void> start() async {
    _printDebugState(DebugCat.appStart, "  --- globalManager start...");
    Box<String> hiveBox = await _HiveUtils.openHiveBoxLoggedInUser();
    String? loggedInUserJson = hiveBox.get(__hiveKeyLoggedInUser);
    await hiveBox.close();

    if (loggedInUserJson == null) {
      _printDebugState(DebugCat.appStart,
          "  --- globalManager loggedInUserJson is null --> return");
      return;
    }
    _printDebugState(DebugCat.appStart,
        "  --- globalManager loggedInUserJson is not null --> continue");
    ILoggedInUser? loggedInUser;
    try {
      loggedInUser = loggedInUserAdapter.fromJson(loggedInUserJson);
    } catch (e, stackTrace) {
      print("****************************************************************");
      print("Error ${getClassName(loggedInUserAdapter)}.fromJson(): $e");
      print("****************************************************************");
      print(stackTrace);
    }
    if (loggedInUser == null) {
      _printDebugState(DebugCat.appStart,
          "  --- globalManager loggedInUser is null --> return");
      // This will open login screen.
      return;
    }
    _printDebugState(DebugCat.appStart,
        "  --- globalManager loggedInUser is not null --> continue");
    IGlobalData? globalData;
    try {
      _loadGlobalDataCount++;

      _printDebugState(DebugCat.appStart,
          "  --- globalManager --> globalData --> globalDataAdapter.loadFromServer()...");
      // Load Global Data:
      globalData = await globalDataAdapter.loadFromServer(
        loggedInUser: loggedInUser,
      );
    } catch (e, stackTrace) {
      print("****************************************************************");
      print("Error ${getClassName(globalDataAdapter)}.loadFromServer(): $e");
      print("****************************************************************");
      print(stackTrace);
    }
    if (globalData == null) {
      _printDebugState(DebugCat.appStart,
          "  --- globalManager --> globalData is null --> return");
      // This will open login screen.
      return;
    }
    _loggedInUser = loggedInUser;
    _globalData = globalData;
    //
    _printDebugState(DebugCat.appStart,
        "  --- globalManager --> __readExtraGlobalProps()...");
    // Load Extra Global Prop Names that stored in Hive Database.
    await __readExtraGlobalProps();
  }

  ///
  /// This method is called when the user logs in successfully.
  ///
  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    if (_loggedInUser != null &&
        _loggedInUser!.userName != loggedInUser.userName) {
      throw Exception("The new and old user must have the same 'userName'"
          " or you must log out before calling this method.");
    }
    if (_loggedInUser == null) {
      _loadGlobalDataCount++;
      // Load GlobalData:
      IGlobalData globalData = await globalDataAdapter.loadFromServer(
        loggedInUser: loggedInUser,
      );
      _globalData = globalData;
    }
    _loggedInUser = loggedInUser;
    // Store on local device:
    Box<String> hiveBox = await _HiveUtils.openHiveBoxLoggedInUser();
    try {
      String json = loggedInUserAdapter.toJson(loggedInUser);
      await hiveBox.put(__hiveKeyLoggedInUser, json);
      await hiveBox.close();
    } catch (e, stackTrace) {
      print("Error setLoggedInUser: $e");
      print(stackTrace);
      return;
    }
    updateWidgets();
  }

  void updateWidgets() {
    for (_RefreshableWidgetState widgetState
    in _loggedInUserWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void _addLoggedInUserWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    _loggedInUserWidgetStates[widgetState] = isShowing;
  }

  void _removeLoggedInUserWidgetState({required State widgetState}) {
    _loggedInUserWidgetStates.remove(widgetState);
  }

  Future<void> _logout() async {
    _loggedInUser = null;
    _globalData = null;
    Box<String> hiveBox = await _HiveUtils.openHiveBoxLoggedInUser();
    await hiveBox.delete(__hiveKeyLoggedInUser);
    await hiveBox.close();
    updateWidgets();
  }
}
