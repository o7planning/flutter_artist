part of '../flutter_artist.dart';

class _GlobalsManager {
  final String __hiveKeyLoggedInUser =
      "---flutter-artist-hive-key-logged-in-user---";

  GlobalData<dynamic>? _globalData;

  ILoggedInUser? _loggedInUser;

  ILoggedInUser? get loggedInUser => _loggedInUser;

  GlobalData<dynamic>? get globalData => _globalData;

  final Map<_RefreshableWidgetState, bool> _loggedInUserWidgetStates = {};

  final LoggedInUserAdapter loggedInUserAdapter;
  final GlobalDataAdapter globalDataAdapter;

  _GlobalsManager({
    required this.loggedInUserAdapter,
    required this.globalDataAdapter,
  });

  Future<void> start() async {
    Box<String> hiveBox = await _openHiveBoxLoggedInUser();
    String? loggedInUserJson = hiveBox.get(__hiveKeyLoggedInUser);
    if (loggedInUserJson == null) {
      return;
    }
    ILoggedInUser? loggedInUser;
    try {
      loggedInUser = loggedInUserAdapter.fromJson(loggedInUserJson);
    } catch (e, stackTrace) {
      print("****************************************************************");
      print("Error ${getClassName(loggedInUserAdapter)}.fromJson(): $e");
      print("****************************************************************");
      print(stackTrace);
      return;
    }
    if (loggedInUser == null) {
      // This will open login screen.
      return;
    }
    // Will not throw Error:
    GlobalData<dynamic>? globalData =
        await __loadGlobalDataFromServer(loggedInUser);
    if (globalData == null) {
      // This will open login screen.
      return;
    }
    _loggedInUser = loggedInUser;
    _globalData = globalData;
  }

  Future<GlobalData<dynamic>?> __loadGlobalDataFromServer(
      ILoggedInUser loggedInUser) async {
    try {
      GlobalData<dynamic> globalData = await globalDataAdapter.loadFromServer(
        loggedInUser: loggedInUser,
      );
      return globalData;
    } catch (e, stackTrace) {
      print("****************************************************************");
      print("Error ${getClassName(globalDataAdapter)}.loadFromServer(): $e");
      print("****************************************************************");
      print(stackTrace);
      return null;
    }
  }

  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    if (loggedInUserAdapter == null) {
      throw _printFatalError(
          " No LoggedInUserAdapter. You need to config it in FlutterArtist.config()");
    }
    if (_loggedInUser != null &&
        _loggedInUser!.userName != loggedInUser.userName) {
      throw Exception("The new and old user must have the same 'userName'"
          " or you must log out before calling this method.");
    }
    _loggedInUser = loggedInUser;
    // Store on local device:
    Box<String> hiveBox = await _openHiveBoxLoggedInUser();
    try {
      String json = loggedInUserAdapter.toJson(loggedInUser);
      hiveBox.put(__hiveKeyLoggedInUser, json);
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
    Box<String> hiveBox = await _openHiveBoxLoggedInUser();
    await hiveBox.delete(__hiveKeyLoggedInUser);
    await hiveBox.close();
    updateWidgets();
  }
}
