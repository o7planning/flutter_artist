part of '../flutter_artist.dart';

final FlutterArtist = _FlutterArtist();

const _isOverlayMode = false;

class _FlutterArtist {
  bool testCaseMode = false;

  final _Storage storage = _Storage();

  final _Executor executor = _Executor();

  final _TaskUnitQueue taskUnitQueue = _TaskUnitQueue();

  int notificationFetchPeriodInSeconds = 60;

  IFlutterArtistAdapter? __adapter;

  late final GlobalsManager globalsManager;

  late final LocaleManager localeManager;

  PostQueryBehavior _defaultPostQueryBehavior =
      PostQueryBehavior.selectAnItemAsCurrentIfNeed;

  PostQueryBehavior get defaultPostQueryBehavior => _defaultPostQueryBehavior;

  Function(BuildContext context)? showRestDebugViewerDialog;

  late final ErrorLogger errorLogger = ErrorLogger(
    maxDisplayErrorCount: 20,
  );

  late final _NotificationEngine __notificationEngine;
  late final CodeFlowLogger codeFlowLogger = CodeFlowLogger();

  final List<IErrorListener> _errorListeners = [];
  final List<INotificationListener> _notificationListeners = [];
  int _totalErrorCount = 0;

  final List<Future<dynamic>> __futureTaskList = [];

  final List<DebugCat> __allowDebugCats = [];

  // ***************************************************************************
  // ***************************************************************************

  _FlutterArtist();

  // ***************************************************************************
  // ***************************************************************************

  bool isAllowDebugCat(DebugCat debugCat) {
    return __allowDebugCats.contains(debugCat);
  }

  // ***************************************************************************
  // ***************************************************************************

  @Deprecated("Do Not Use")
  void resetForTestOnly() {
    storage._resetForTestOnly();
  }

  @Deprecated("Do Not Use, Test Only")
  void setDefaultPostQueryBehavior(PostQueryBehavior defaultPostQueryBehavior) {
    _defaultPostQueryBehavior = defaultPostQueryBehavior;
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
    await globalsManager._logout();
    offAllAndGotoRoute();
  }

  IFlutterArtistAdapter get adapter {
    if (__adapter == null) {
      throw _printFatalError(
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
  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    await globalsManager.setOrUpdateLoggedInUser(loggedInUser);
  }

  Future<void> config({
    required IFlutterArtistAdapter flutterArtistAdapter,
    required INotificationAdapter? notificationAdapter,
    required ILoggedInUserAdapter loggedInUserAdapter,
    required IGlobalDataAdapter globalDataAdapter,
    required ILocaleAdapter localeAdapter,
    required Function(BuildContext context)? showRestDebugDialog,
    int notificationFetchPeriodInSeconds = 60,
    List<DebugCat> allowDebugCats = const [],
  }) async {
    if (__adapter != null) {
      throw _printFatalError("${getClassName(__adapter)} already registered!");
    }
    __adapter = flutterArtistAdapter;
    //
    __allowDebugCats
      ..clear()
      ..addAll(allowDebugCats);
    //
    globalsManager = GlobalsManager._(
      loggedInUserAdapter: loggedInUserAdapter,
      globalDataAdapter: globalDataAdapter,
    );
    localeManager = LocaleManager._(
      globalsManager: globalsManager,
      localeAdapter: localeAdapter,
    );
    //
    showRestDebugViewerDialog = showRestDebugDialog;
    //
    this.notificationFetchPeriodInSeconds = notificationFetchPeriodInSeconds;
    //
    __notificationEngine = _NotificationEngine(notificationAdapter);
    //
    // START ALL:
    //
    await globalsManager.start();
    // IMPORTANT: No await:
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
    await _showErrorLogViewerDialog(
      context: context,
      errorLogger: errorLogger,
    );
  }

  bool hasRecentErrors() {
    return errorLogger.errorCount != 0;
  }

  void _notifyError() {
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
}
