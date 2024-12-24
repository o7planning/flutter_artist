part of '../flutter_artist.dart';

class _LoggedInUserManager {
  final String __hiveKeyLoggedInUser = "---flu-logged-in-user-hive-key---";

  ILoggedInUser? _loggedInUser;

  ILoggedInUser? get loggedInUser => _loggedInUser;

  final Map<_WidgetState, bool> _widgetStateListeners = {};

  Future<void> _logout() async {
    _loggedInUser = null;
    Box<String> hiveBox = await _openHiveBoxLoggedInUser();
    await hiveBox.delete(__hiveKeyLoggedInUser);
    await hiveBox.close();
    updateWidgets();
  }

  // Callable in this Library.
  Future<void> _initFromLocal() async {
    LoggedInUserAdapter? loggedInUserAdapter = StorageX.loggedInUserAdapter;
    if (loggedInUserAdapter == null) {
      return;
    }
    Box<String> hiveBox = await _openHiveBoxLoggedInUser();
    String? loggedInUserJson = hiveBox.get(__hiveKeyLoggedInUser);
    if (loggedInUserJson == null) {
      return;
    }
    try {
      _loggedInUser = loggedInUserAdapter.fromJson(loggedInUserJson);
    } catch (e, stackTrace) {
      print("****************************************************************");
      print("Error ${getClassName(this)}._initFromLocal: $e");
      print("****************************************************************");
      print(stackTrace);
      return;
    }
  }

  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    LoggedInUserAdapter? loggedInUserAdapter = StorageX.loggedInUserAdapter;
    if (loggedInUserAdapter == null) {
      throw "\n***************************************************************"
          "\n No LoggedInUserAdapter. You need to config it in GlobalFlu.config()"
          "\n***************************************************************";
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
    for (_WidgetState widgetState in _widgetStateListeners.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _widgetStateListeners[widgetState] = isShowing;
  }

  void _removeWidgetStateListener({required State widgetState}) {
    _widgetStateListeners.remove(widgetState);
  }
}
