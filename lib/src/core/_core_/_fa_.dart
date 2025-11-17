part of 'core.dart';

final FlutterArtist = _FlutterArtist();

const _isOverlayMode = false;

class _FlutterArtist {
  _FlutterArtistNavigatorObserver? __navigatorObserver;

  _FlutterArtistNavigatorObserver get navigatorObserver {
    if (__navigatorObserver == null) {
      // IMPORTANT:
      // LOGIC: #0001
      storage._setStarted();
      __navigatorObserver = _FlutterArtistNavigatorObserver();
    }
    return __navigatorObserver!;
  }

  bool testCaseMode = false;

  var __debugOptions = DebugOptions();

  DebugOptions get debugOptions => __debugOptions;

  var __consoleDebugOptions = ConsoleDebugOptions(enabled: false);

  ConsoleDebugOptions get consoleDebugOptions => __consoleDebugOptions;

  final _Storage storage = _Storage();

  final _Executor executor = _Executor();

  final _BackgroundExecutor backgroundExecutor = _BackgroundExecutor();

  final _XRootQueue _rootQueue = _XRootQueue();

  DebugXShelfQueue get debugTaskUnitQueue => _rootQueue.toDebugXShelfQueue();

  int notificationFetchPeriodInSeconds = 60;

  IFlutterArtistAdapter? __adapter;

  late final GlobalsManager globalsManager;

  late final LocaleManager localeManager;

  AfterQueryAction _defaultAfterQueryAction =
      AfterQueryAction.setAnItemAsCurrentIfNeed;

  AfterQueryAction get defaultAfterQueryAction => _defaultAfterQueryAction;

  Function(BuildContext context)? showRestDebugViewerDialog;

  late final ErrorLogger errorLogger = ErrorLogger(
    maxDisplayErrorCount: 20,
  );

  late final _NotificationEngine __notificationEngine;
  late final CodeFlowLogger codeFlowLogger = CodeFlowLogger();

  final List<IErrorListener> _errorListeners = [];
  final List<INotificationListener> _notificationListeners = [];

  int _totalErrorCount = 0;

  int get totalErrorCount => _totalErrorCount;

  final List<Future<dynamic>> __futureTaskList = [];

  // ***************************************************************************
  // ***************************************************************************

  _FlutterArtist();

  // ***************************************************************************
  // ***************************************************************************

  @Deprecated("Do Not Use")
  void resetForTestOnly() {
    storage._resetForTestOnly();
  }

  @Deprecated("Do Not Use, Test Only")
  void debugSetDefaultAfterQueryAction(
      AfterQueryAction defaultAfterQueryAction) {
    _defaultAfterQueryAction = defaultAfterQueryAction;
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
    storage._recentShelves.clear();
    await globalsManager._logout();
    offAllAndGotoRoute();
  }

  IFlutterArtistAdapter get adapter {
    if (__adapter == null) {
      throw DebugUtils.getFatalError(
          " >>>>>> $IFlutterArtistAdapter is not registered!. "
          "\n >>>>>> You need to call $FlutterArtist.config() in main.dart");
    }
    return __adapter!;
  }

  // docs: [14683].
  ILoggedInUser? get loggedInUser {
    return globalsManager.loggedInUser;
  }

  IGlobalData? get globalData {
    return globalsManager.globalData;
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
  Future<void> _setOrUpdateLoggedInUser({
    required ILoggedInUser loggedInUser,
    required bool requiresTheSameUser,
  }) async {
    await globalsManager.setOrUpdateLoggedInUser(
      loggedInUser: loggedInUser,
      requiresTheSameUser: requiresTheSameUser,
    );
  }

  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    await _setOrUpdateLoggedInUser(
        loggedInUser: loggedInUser, requiresTheSameUser: true);
  }

  void _printDebugState(String message) {
    DebugPrinter.printDebug(
      DebugCat.appStart,
      "FlutterArtist.config ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> $message",
    );
  }

  Future<void> config({
    required DebugOptions? debugOptions,
    required ConsoleDebugOptions? consoleDebugOptions,
    required IFlutterArtistAdapter flutterArtistAdapter,
    required INotificationAdapter? notificationAdapter,
    required ILoggedInUserAdapter loggedInUserAdapter,
    required IGlobalDataAdapter globalDataAdapter,
    required ILocaleAdapter localeAdapter,
    required Function(BuildContext context)? showRestDebugDialog,
    int notificationFetchPeriodInSeconds = 60,
  }) async {
    if (__adapter != null) {
      throw DebugUtils.getFatalError(
          "${getClassName(__adapter)} already registered!");
    }
    __adapter = flutterArtistAdapter;
    //
    if (debugOptions != null) {
      __debugOptions = debugOptions;
    }
    if (consoleDebugOptions != null) {
      __consoleDebugOptions = consoleDebugOptions;
    }
    //
    _printDebugState("start");
    //
    // Global Manager:
    //
    globalsManager = GlobalsManager._(
      loggedInUserAdapter: loggedInUserAdapter,
      globalDataAdapter: globalDataAdapter,
    );
    _printDebugState("globalsManager start...");
    await globalsManager.start();
    _printDebugState("globalsManager loggedInUser: $loggedInUser");
    //
    // Locale Manager:
    //
    localeManager = LocaleManager._(
      globalsManager: globalsManager,
      localeAdapter: localeAdapter,
    );
    _printDebugState("localeManager readStoredLocale()");
    final Locale? locale = localeManager.readStoredLocale();
    _printDebugState("localeManager readStoredLocale() -> locale: $locale");
    if (locale != null) {
      _printDebugState("localeManager _updateLocale() delay 2s (***)");
      Future.delayed(Duration(seconds: 2), () async {
        await localeManager._updateLocale(locale: locale);
      });
    }
    //
    showRestDebugViewerDialog = showRestDebugDialog;
    //
    // Notification:
    //
    this.notificationFetchPeriodInSeconds = notificationFetchPeriodInSeconds;
    __notificationEngine = _NotificationEngine(notificationAdapter);
    //
    // IMPORTANT: No await:
    //
    _printDebugState("__notificationEngine start()");
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

  Future<void> showUiComponentsDialog() async {
    Shelf? shelf = storage._recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showActiveUiComponentsDialog();
  }

  Future<dynamic> _executeTask({
    bool showOverlay = true,
    required Future<dynamic> Function() asyncFunction,
  }) {
    Future<dynamic> future = asyncFunction();
    __futureTaskList.add(future);
    future.whenComplete(() {
      if (_isOverlayMode) {
        // Default 30:
        Future.delayed(const Duration(milliseconds: 0), () {
          __futureTaskList.remove(future);
        });
      } else {
        __futureTaskList.remove(future);
      }
    });
    if (showOverlay) {
      _showOverlayIfNeed();
    }
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
            // Default?
            const Duration(milliseconds: 0),
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
    await StorageDialog.showStorageDialog(context: context, shelf: null);
  }

  Future<void> showCodeFlowViewerDialog() async {
    BuildContext context = adapter.getCurrentContext();
    await CodeFlowViewerDialog.showCodeFlowViewerDialog(context: context);
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
    //
    await ErrorLogViewerDialog.showErrorLogViewerDialog(
      context: context,
      errorLogger: errorLogger,
    );
  }

  bool hasRecentErrors() {
    return errorLogger.errorCount != 0;
  }

  // TODO: (Internal)
  void internalIncreaseTotalErrorCount() {
    _totalErrorCount++;
  }

  // TODO: (Internal)
  void internalNotifyError() {
    Future.delayed(
      Duration.zero,
      () {
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
      },
    );
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

  bool debugCanShowUiComponentDialog() {
    Shelf? shelf = storage._recentShelf();
    return shelf != null;
  }
}
