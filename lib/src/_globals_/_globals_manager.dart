part of '../../flutter_artist.dart';

class _GlobalsManager {
  final String __hiveKeyLoggedInUser =
      "---flutter-artist-hive-key-logged-in-user---";

  IGlobalData? _globalData;

  ILoggedInUser? _loggedInUser;

  ILoggedInUser? get loggedInUser => _loggedInUser;

  IGlobalData? get globalData => _globalData;

  final Map<_RefreshableWidgetState, bool> _loggedInUserWidgetStates = {};

  final ILoggedInUserAdapter loggedInUserAdapter;
  final IGlobalDataAdapter globalDataAdapter;

  _GlobalsManager({
    required this.loggedInUserAdapter,
    required this.globalDataAdapter,
  });

  ///
  /// This method is called only once when FlutterArtist is started.
  ///
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
    }
    if (loggedInUser == null) {
      // This will open login screen.
      return;
    }
    IGlobalData? globalData;
    try {
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
      // This will open login screen.
      return;
    }
    _loggedInUser = loggedInUser;
    _globalData = globalData;
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
      // Load GlobalData:
      IGlobalData globalData = await globalDataAdapter.loadFromServer(
        loggedInUser: loggedInUser,
      );
      _globalData = globalData;
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
    _globalData = null;
    Box<String> hiveBox = await _openHiveBoxLoggedInUser();
    await hiveBox.delete(__hiveKeyLoggedInUser);
    await hiveBox.close();
    updateWidgets();
  }
}
