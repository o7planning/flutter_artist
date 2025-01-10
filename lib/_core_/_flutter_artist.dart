part of '../flutter_artist.dart';

typedef ShelfCreator<S> = S Function();

final FlutterArtist = _FlutterArtist();

const _isOverlayMode = false;

class _FlutterArtist {
  final _Storage storage = _Storage();

  int notificationFetchPeriodInSeconds = 60;

  FlutterArtistAdapter? __adapter;

  final _LoggedInUserManager _loggedInUserManager = _LoggedInUserManager();
  LoggedInUserAdapter? __loggedInUserAdapter;
  NotificationAdapter? __notificationAdapter;

  Function(BuildContext context)? _showRestDebugDialog;

  late final ErrorLogger errorLogger = ErrorLogger(
    maxDisplayErrorCount: 20,
  );

  late final _NotificationEngine __notificationEngine;
  late final CodeFlowLogger codeFlowLogger = CodeFlowLogger();

  final List<IErrorListener> _errorListeners = [];
  final List<INotificationListener> _notificationListeners = [];
  int _totalErrorCount = 0;

  final List<Future<dynamic>> __futureTaskList = [];

  _Storage? get globalFluData {
    return storage;
  }

  ///
  /// GetX sample code:
  /// ```dart
  /// FlutterArtist.logout(offAllAndGotoRoute: () {
  ///    Get.offAllNamed(LoginScreen.routeName);
  /// });
  /// ```
  ///
  Future<void> logout({required Function() offAllAndGotoRoute}) async {
    _totalErrorCount = 0;
    storage._logout();
    storage._rencentShelves.clear();
    await _loggedInUserManager._logout();
    offAllAndGotoRoute();
  }

  FlutterArtistAdapter get adapter {
    if (__adapter == null) {
      throw "\n*************************************************************"
          "\n >>>>>> FlutterArtistAdapter is not registered!. "
          "\n >>>>>> You need to call FlutterArtist.config() in main.dart"
          "\n*************************************************************";
    }
    return __adapter!;
  }

  NotificationAdapter? get notificationAdapter {
    return __notificationAdapter;
  }

  LoggedInUserAdapter? get loggedInUserAdapter {
    return __loggedInUserAdapter;
  }

  ILoggedInUser? get loggedInUser {
    return _loggedInUserManager.loggedInUser;
  }

  ///
  /// Sets or updates the logged in User.
  ///
  /// This method will throw an error if the new user and the old user do not have the same username.
  ///
  /// ```dart
  /// if(oldLoggedInUser != null
  ///           && oldLoggedInUser!.userName != loggedInUser.userName) {
  ///    throw Exception("You need to log out before setting up a new user.");
  /// }
  /// ```
  ///
  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    await _loggedInUserManager.setOrUpdateLoggedInUser(loggedInUser);
  }

  Future<void> config({
    required FlutterArtistAdapter flutterArtistAdapter,
    required NotificationAdapter? notificationAdapter,
    required LoggedInUserAdapter? loggedInUserAdapter,
    required Function(BuildContext context)? showRestDebugDialog,
    int notificationFetchPeriodInSeconds = 60,
  }) async {
    if (__adapter != null) {
      throw "FlutterArtistAdapter already registered!";
    }
    __adapter = flutterArtistAdapter;
    //
    __loggedInUserAdapter = loggedInUserAdapter;
    await _loggedInUserManager._initFromLocal();
    //
    _showRestDebugDialog = showRestDebugDialog;
    //
    __notificationAdapter = notificationAdapter;
    //
    this.notificationFetchPeriodInSeconds = notificationFetchPeriodInSeconds;
    //
    // FluNotificationAdapter ready, start Notification
    //
    __notificationEngine = _NotificationEngine();
    __notificationEngine.start();
  }

  void addErrorListener(IErrorListener listener) {
    if (!_errorListeners.contains(listener)) {
      _errorListeners.add(listener);
    }
  }

  void removeErrorListener(IErrorListener listener) {
    _errorListeners.remove(listener);
  }

  void addNotificationListener(INotificationListener listener) {
    if (!_notificationListeners.contains(listener)) {
      _notificationListeners.add(listener);
    }
  }

  void removeNotificationListener(INotificationListener listener) {
    _notificationListeners.remove(listener);
  }

  bool _canShowUiComponentDialog() {
    Shelf? shelf = storage._recentShelf();
    return shelf != null;
  }

  Future<void> showUiComponentsDialog() async {
    Shelf? shelf = storage._recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showActiveUiComponentsDialog();
  }

  Future<dynamic> executeTask({
    required Future<dynamic> Function() asyncFunction,
  }) {
    Future<dynamic> future = asyncFunction();
    __futureTaskList.add(future);
    future.whenComplete(() {
      if (_isOverlayMode) {
        Future.delayed(const Duration(milliseconds: 30), () {
          __futureTaskList.remove(future);
        });
      } else {
        __futureTaskList.remove(future);
      }
    });
    _showOverlayIfNeed();
    return future;
  }

  void _showOverlayIfNeed() {
    if (isOverlaysOpen()) {
      return;
    }
    showOverlay(
      asyncFunction: () async {
        await Future.doWhile(
          () => Future.delayed(
            const Duration(milliseconds: 5),
          ).then(
            (_) {
              return __futureTaskList.isNotEmpty;
            },
          ),
        );
      },
    );
  }

  Future<void> showOverlay({
    required Future<dynamic> Function() asyncFunction,
  }) async {
    await adapter.showOverlay(
      opacity: _isOverlayMode ? 0.3 : 0.02,
      asyncFunction: asyncFunction,
    );
  }

  bool isOverlaysOpen() {
    return adapter.isOverlaysOpen();
  }

  Future<void> showStorageDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await _showStorageDialog(context: context, shelf: null);
  }

  Future<void> showFlowLogDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await _showFlowLogViewerDialog(context: context);
  }

  Future<void> showShelfStructure() async {
    Shelf? shelf = storage._recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showShelfStructureDialog();
  }

  bool canShowShelfStructure() {
    Shelf? shelf = storage._recentShelf();
    return shelf != null;
  }

  Future<void> showRecentErrors() async {
    showErrorViewerDialog();
  }

  Future<void> showErrorViewerDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await _showErrorViewerDialog(
      context: context,
      errorLogger: errorLogger,
    );
  }

  bool hasRecentErrors() {
    return errorLogger.errorCount != 0;
  }

  void _notifyError() {
    for (IErrorListener listener in [..._errorListeners]) {
      if (listener is State) {
        State state = listener as State;
        if (!state.mounted) {
          _errorListeners.remove(listener);
          continue;
        }
      }
      listener.onError();
    }
  }

  void _notifyNotification(INotificationSummary notificationSummary) {
    for (INotificationListener listener in [..._notificationListeners]) {
      if (listener is State) {
        State state = listener as State;
        if (!state.mounted) {
          _errorListeners.remove(listener);
          continue;
        }
      }
      listener.handleNotification(notificationSummary);
    }
  }
}
