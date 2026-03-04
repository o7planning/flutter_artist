part of 'core.dart';

final FlutterArtist = _FlutterArtist();

const _isOverlayMode = false;

class _FlutterArtist extends _Core {
  bool _lockAddMoreQuery = false;
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

  final debugRegister = _DebugRegister();

  var __debugOptions = DebugOptions();

  DebugOptions get debugOptions => __debugOptions;

  var __consoleDebugOptions = ConsoleDebugOptions(enabled: false);

  ConsoleDebugOptions get consoleDebugOptions => __consoleDebugOptions;

  final storage = _Storage();

  final executor = _Executor();

  final backgroundExecutor = _BackgroundExecutor();

  final _rootQueue = _XRootQueue();

  DebugXRootQueue get debugTaskUnitQueue => _rootQueue.toDebugXRootQueue();

  int notificationFetchPeriodInSeconds = 60;

  FlutterArtistCoreFeaturesAdapter? __coreFeaturesAdapter;

  late final GlobalsManager globalsManager;

  late final LocaleManager localeManager;

  AfterQueryAction _defaultAfterQueryAction =
      AfterQueryAction.setAnItemAsCurrentIfNeed;

  AfterQueryAction get defaultAfterQueryAction => _defaultAfterQueryAction;

  Function(BuildContext context)? showRestDebugViewerDialog;

  late final _NotificationEngine __notificationEngine;

  late final Logger logger;
  late final CodeFlowLogger codeFlowLogger;

  final List<ILogListener> _logListeners = [];
  final List<INotificationListener> _notificationListeners = [];

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
    logger.clear();
    storage._logout();
    storage._recentShelves.clear();
    await globalsManager._logout();
    offAllAndGotoRoute();
  }

  FlutterArtistCoreFeaturesAdapter get coreFeaturesAdapter {
    if (__coreFeaturesAdapter == null) {
      throw DebugUtils.getFatalError(
          " >>>>>> $FlutterArtistCoreFeaturesAdapter is not registered!. "
          "\n >>>>>> You need to call $FlutterArtist.config() in main.dart");
    }
    return __coreFeaturesAdapter!;
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
  Future<bool> _setOrUpdateLoggedInUser({
    required ExecutionTrace executionTrace,
    required ILoggedInUser loggedInUser,
    required bool requiresTheSameUser,
  }) async {
    executionTrace._addTraceStep(
      codeId: "#21000",
      shortDesc: "Calling <b>globalsManager._setOrUpdateLoggedInUser()</b>.",
      parameters: {
        "loggedInUser": loggedInUser,
        "requiresTheSameUser": requiresTheSameUser,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    // This method never throw error.
    return await globalsManager._setOrUpdateLoggedInUserSafely(
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
      requiresTheSameUser: requiresTheSameUser,
    );
  }

  Future<void> removeStoredLoggedInUser() async {
    await globalsManager.removeStoredLoggedInUser();
  }

  Future<void> setOrUpdateLoggedInUser(ILoggedInUser loggedInUser) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "setOrUpdateLoggedInUser",
      parameters: {
        "loggedInUser": loggedInUser,
      },
      navigate: null,
      isLibMethod: true,
    );
    await _setOrUpdateLoggedInUser(
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
      requiresTheSameUser: true,
    );
  }

  // Docs: [14841] - FlutterArtist Config.
  Future<void> config({
    required StorageStructure storageStructure,
    required DebugOptions? debugOptions,
    required ConsoleDebugOptions? consoleDebugOptions,
    required FlutterArtistCoreFeaturesAdapter coreFeaturesAdapter,
    required FlutterArtistNotificationAdapter? notificationAdapter,
    required FlutterArtistLoginLogoutAdapter loginLogoutAdapter,
    required FlutterArtistGlobalDataAdapter globalDataAdapter,
    required FlutterArtistLocaleAdapter localeAdapter,
    required Function(BuildContext context)? showRestDebugDialog,
    int notificationFetchPeriodInSeconds = 60,
    int maxStoredLogEntryCount = 20,
    int codeFlowRetentionPeriodInSeconds = 20,
  }) async {
    if (__coreFeaturesAdapter != null) {
      throw DebugUtils.getFatalError(
          "${getClassName(__coreFeaturesAdapter)} already registered!");
    }
    // IMPORTANT: Call this before using ExecutionTrace.
    codeFlowLogger = CodeFlowLogger(
        codeFlowRetentionPeriodInSeconds: codeFlowRetentionPeriodInSeconds);

    final executionTrace =
        FlutterArtist.codeFlowLogger._addStartup(ownerClassInstance: this);
    try {
      await __config(
        executionTrace: executionTrace,
        storageStructure: storageStructure,
        debugOptions: debugOptions,
        consoleDebugOptions: consoleDebugOptions,
        coreFeaturesAdapter: coreFeaturesAdapter,
        notificationAdapter: notificationAdapter,
        loginLogoutAdapter: loginLogoutAdapter,
        globalDataAdapter: globalDataAdapter,
        localeAdapter: localeAdapter,
        showRestDebugDialog: showRestDebugDialog,
        notificationFetchPeriodInSeconds: notificationFetchPeriodInSeconds,
        maxStoredLogEntryCount: maxStoredLogEntryCount,
        codeFlowRetentionPeriodInSeconds: codeFlowRetentionPeriodInSeconds,
      );
    } catch (e, stackTrace) {
      executionTrace.printToConsole();
      print("\n\n");
      __showStartupError(executionTrace: executionTrace, error: e);
      rethrow;
    }
  }

  Future<void> __config({
    required ExecutionTrace executionTrace,
    required StorageStructure storageStructure,
    required DebugOptions? debugOptions,
    required ConsoleDebugOptions? consoleDebugOptions,
    required FlutterArtistCoreFeaturesAdapter coreFeaturesAdapter,
    required FlutterArtistNotificationAdapter? notificationAdapter,
    required FlutterArtistLoginLogoutAdapter loginLogoutAdapter,
    required FlutterArtistGlobalDataAdapter globalDataAdapter,
    required FlutterArtistLocaleAdapter localeAdapter,
    required Function(BuildContext context)? showRestDebugDialog,
    required int notificationFetchPeriodInSeconds,
    required int maxStoredLogEntryCount,
    required int codeFlowRetentionPeriodInSeconds,
  }) async {
    logger = Logger(maxStoredLogEntryCount: maxStoredLogEntryCount);
    //
    executionTrace._addTraceStep(
      codeId: "#S0000",
      shortDesc: "Begin FlutterArtist Config...\n"
          "Note: You see this debug information because the <b>FlutterArtist.config()</b> method is called in <b>main.dart</b>.",
      parameters: {
        "storageStructure": storageStructure,
        "coreFeaturesAdapter": coreFeaturesAdapter,
        "loginLogoutAdapter": loginLogoutAdapter,
        "globalDataAdapter": globalDataAdapter,
        "notificationAdapter": notificationAdapter,
        "maxStoredLogEntryCount": maxStoredLogEntryCount,
        "notificationFetchPeriodInSeconds": notificationFetchPeriodInSeconds,
      },
      lineFlowType: LineFlowType.debug,
      tipDocument: TipDocument.config,
    );
    //
    __coreFeaturesAdapter = coreFeaturesAdapter;
    //
    if (debugOptions != null) {
      __debugOptions = debugOptions;
    }
    if (consoleDebugOptions != null) {
      __consoleDebugOptions = consoleDebugOptions;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#S0200",
      shortDesc: "Calling <b>storage._init()</b> with parameters:",
      parameters: {
        "storageStructure": storageStructure,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
      tipDocument: TipDocument.storageStructure,
    );
    // This method may throw error and stop app.
    storage._init(
      executionTrace: executionTrace,
      storageStructure: storageStructure,
    );
    //
    // Global Manager:
    //
    executionTrace._addTraceStep(
      codeId: "#S0400",
      shortDesc: "Creating <b>globalsManager</b>..",
      tipDocument: TipDocument.globalData,
    );
    globalsManager = GlobalsManager._(
      loginLogoutAdapter: loginLogoutAdapter,
      globalDataAdapter: globalDataAdapter,
    );
    executionTrace._addTraceStep(
      codeId: "#S0500",
      shortDesc: "Calling <b>globalsManager._init()</b>...",
      note:
          "This method will read all the user data that was previously stored in <b>Local</b>.",
      lineFlowType: LineFlowType.nonControllableCalling,
      tipDocument: TipDocument.globalData,
    );
    await globalsManager._init(executionTrace);
    //
    // Locale Manager:
    //
    localeManager = LocaleManager._(
      globalsManager: globalsManager,
      localeAdapter: localeAdapter,
    );
    //
    final ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    //
    if (loggedInUser != null) {
      executionTrace._addTraceStep(
        codeId: "#S0540",
        shortDesc: "Automatic authentication successful!",
        parameters: {
          "loggedInUser": loggedInUser,
        },
      );
      executionTrace._addTraceStep(
        codeId: "#S0560",
        shortDesc:
            "Calling <b>localeManager._readStoredLocale()</b> to read saved locale from <b>Local</b>...",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      final Locale? locale = localeManager._readStoredLocale(
        loggedInUser: loggedInUser,
        executionTrace: executionTrace,
      );
      executionTrace._addTraceStep(
        codeId: "#S0580",
        shortDesc: "Got stored @locale: ${debugObjHtml(locale)}.",
      );
      if (locale != null) {
        executionTrace._addTraceStep(
          codeId: "#S0620",
          shortDesc: "Calling <b>localeManager._updateLocale()</b>:",
          parameters: {
            "locale": locale,
          },
          lineFlowType: LineFlowType.nonControllableCalling,
        );
        Future.delayed(Duration(seconds: 2), () async {
          await localeManager._updateLocale(
            executionTrace: executionTrace,
            locale: locale,
          );
        });
      }
    }
    //
    showRestDebugViewerDialog = showRestDebugDialog;
    //
    // Notification:
    //
    this.notificationFetchPeriodInSeconds = notificationFetchPeriodInSeconds;
    __notificationEngine = _NotificationEngine(notificationAdapter);
    //
    executionTrace._addTraceStep(
      codeId: "#S0680",
      shortDesc: "Start notificationEngine.",
    );
    //
    // IMPORTANT: No await:
    //
    __notificationEngine.start();
  }

  void addLogListener(ILogListener listener) {
    if (!_logListeners.contains(listener)) {
      _logListeners.add(listener);
    }
  }

  void removeLogListener(ILogListener listener) {
    _logListeners.remove(listener);
  }

  void addNotificationListener(INotificationListener listener) {
    if (!_notificationListeners.contains(listener)) {
      _notificationListeners.add(listener);
    }
  }

  void removeNotificationListener(INotificationListener listener) {
    _notificationListeners.remove(listener);
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
    await coreFeaturesAdapter.showOverlay(
      opacity: _isOverlayMode ? 0.3 : 0.02,
      asyncFunction: asyncFunction,
    );
  }

  bool isOverlaysOpen() {
    return coreFeaturesAdapter.isOverlaysOpen();
  }

  Future<void> showCodeFlowViewerDialog() async {
    BuildContext context = coreFeaturesAdapter.getCurrentContext();
    await CodeFlowViewerDialog.open(context: context);
  }

  Future<void> showDebugShelfStructureViewerDialog() async {
    Shelf? shelf = storage._recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showDebugShelfStructureViewerDialog();
  }

  bool canShowDebugShelfStructureViewerDialog() {
    Shelf? shelf = storage._recentShelf();
    return shelf != null;
  }

  Future<void> showLogViewerDialog({int? logEntryId}) async {
    BuildContext context = coreFeaturesAdapter.getCurrentContext();
    //
    await LogViewerDialog.open(
      context: context,
      logger: logger,
      logEntryId: logEntryId,
    );
  }

  // TODO: (Internal)
  void internalNotifyLog() {
    Future.delayed(
      Duration.zero,
      () {
        for (ILogListener listener in [..._logListeners]) {
          if (listener is State) {
            State state = listener as State;
            if (!state.mounted) {
              _logListeners.remove(listener);
              continue;
            }
          }
          listener.onLog();
        }
      },
    );
  }

  void _notifyNotification(INotificationSummary notificationSummary) {
    for (INotificationListener listener in [..._notificationListeners]) {
      if (listener is State) {
        State state = listener as State;
        if (!state.mounted) {
          _logListeners.remove(listener);
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

  void showDebugMenu({
    required BuildContext context,
    RelativeRect? position,
    PopupMenuPositionBuilder? positionBuilder,
  }) {
    DebugMenuBuilder.build().show(
      context: context,
      position: position,
      positionBuilder: positionBuilder,
    );
  }

  void __showStartupError({
    required ExecutionTrace executionTrace,
    required Object error,
  }) {
    runApp(_StartupErrorViewer(executionTrace: executionTrace, error: error));
  }
}
