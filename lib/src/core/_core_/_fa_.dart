part of 'core.dart';

final FlutterArtist = _FlutterArtist();

const _isOverlayMode = false;

class _FlutterArtist extends _Core {
  bool __started = false;
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

  final Set<RouteKey> __commonRouteKeys = {};

  late final FlutterArtistRouter router;

  bool testCaseMode = false;

  final debugRegister = _DebugRegister();

  final clock = FaSystemClock();

  final garbageCollector = _GarbageCollector();

  final garbageScheduler = _GarbageScheduler();

  late final storage = _Storage();

  final executor = _Executor();

  final backgroundExecutor = _BackgroundExecutor();

  final _rootQueue = _XRootQueue();

  DebugXRootQueue get debugTaskUnitQueue => _rootQueue.toDebugXRootQueue();

  late final GlobalsManager globalsManager;

  late final LocaleManager localeManager;

  late final ThemeManager themeManager;

  late final RuntimeAppConfig appConfig;

  BlockAfterQueryDirective _defaultAfterQueryDirective =
      BlockAfterQueryDirective.setAnItemAsCurrentIfNeed;

  BlockAfterQueryDirective get defaultAfterQueryDirective =>
      _defaultAfterQueryDirective;

  late final FlutterArtistNotificationService? __notificationService;

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

  void _addCommonRouteKey(RouteKey routeKey) {
    __commonRouteKeys.add(routeKey);
  }

  void _removeCommonRouteKey(RouteKey routeKey) {
    __commonRouteKeys.remove(routeKey);
  }

  bool isCommonRouteKey(RouteKey routeKey) {
    return __commonRouteKeys.contains(routeKey);
  }

  // ***************************************************************************

  @Deprecated("Do Not Use")
  void resetForTestOnly() {
    storage._resetForTestOnly();
  }

  @Deprecated("Do Not Use, Test Only")
  void debugSetDefaultAfterQueryDirective(
      BlockAfterQueryDirective defaultAfterQueryDirective) {
    _defaultAfterQueryDirective = defaultAfterQueryDirective;
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
      traceStepType: TraceStepType.nonControllableCalling,
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
      isLibMethod: true,
    );
    await _setOrUpdateLoggedInUser(
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
      requiresTheSameUser: true,
    );
  }

  // Docs: [14841] - FlutterArtist Start.
  Future<void> start({
    required AppConfiguration appConfiguration,
    required FlutterArtistRouter router,
  }) async {
    print("[FLUTTER-ARTIST] - FlutterArtist.start() - BEGIN");
    if (__started) {
      throw DebugUtils.getFatalError("App already started!");
    }
    __started = true;
    //
    appConfig = RuntimeAppConfig.fromConfiguration(appConfiguration);
    this.router = router;
    // IMPORTANT: Call this before using ExecutionTrace.
    codeFlowLogger = CodeFlowLogger(
      codeFlowRetentionPeriod: appConfig.codeFlowRetentionPeriod,
    );

    final executionTrace =
        FlutterArtist.codeFlowLogger._addStartup(ownerClassInstance: this);
    try {
      await __start(executionTrace: executionTrace);
      garbageScheduler.start();
    } catch (e, _) {
      executionTrace.printToConsole();
      print("\n\n");
      __showStartupError(executionTrace: executionTrace, error: e);
      rethrow;
    }
    print("[FLUTTER-ARTIST] - FlutterArtist.start() - DONE");
  }

  Future<void> __start({
    required ExecutionTrace executionTrace,
  }) async {
    await FaIsarStorage.init();
    logger = Logger(maxStoredLogEntryCount: appConfig.maxStoredLogEntryCount);
    //
    executionTrace._addTraceStep(
      codeId: "#S0000",
      shortDesc: "Begin FlutterArtist Config...\n"
          "Note: You see this debug information because the <b>FlutterArtist.start()</b> method is called in <b>main.dart</b>.",
      parameters: {},
      traceStepType: TraceStepType.debug,
      tipDocument: TipDocument.start,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#S0200",
      shortDesc: "Calling <b>storage._init()</b> with parameters:",
      parameters: {
        "appConfig": appConfig,
      },
      traceStepType: TraceStepType.nonControllableCalling,
      tipDocument: TipDocument.appConfiguration,
    );
    // This method may throw error and stop app.
    storage._init(
      executionTrace: executionTrace,
      appConfig: appConfig,
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
      loginLogoutAdapter: appConfig._loginLogoutAdapter,
      globalDataAdapter: appConfig._globalDataAdapter,
    );
    executionTrace._addTraceStep(
      codeId: "#S0500",
      shortDesc: "Calling <b>globalsManager._init()</b>...",
      note:
          "This method will read all the user data that was previously stored in <b>Local</b>.",
      traceStepType: TraceStepType.nonControllableCalling,
      tipDocument: TipDocument.globalData,
    );
    await globalsManager._init(executionTrace);
    //
    // Theme Manager:
    //
    themeManager = ThemeManager._(
      globalsManager: globalsManager,
    );
    //
    // Locale Manager:
    //
    localeManager = LocaleManager._(
      globalsManager: globalsManager,
      localeAdapter: FlutterArtistLocaleAdapter(
        updateLocale: (Locale locale) async {
          await appConfig._updateLocale(locale: locale);
        },
      ),
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
            "Calling <b>localeManager._getStoredLocalLocale()</b> to read saved locale from <b>Local</b>...",
        traceStepType: TraceStepType.nonControllableCalling,
      );
      final Locale? locale = localeManager.storedLocale;

      executionTrace._addTraceStep(
        codeId: "#S0580",
        shortDesc: "Got stored @locale: ${debugObjHtml(locale)}.",
      );
    }
    //
    // Notification:
    //
    final notiAdapter = appConfig._notificationAdapter;
    if (notiAdapter == null) {
      __notificationService = null;
    } else if (notiAdapter is SimpleNotificationAdapter) {
      __notificationService = SimpleNotificationService(notiAdapter);
    } else if (notiAdapter is FirebaseNotificationAdapter) {
      __notificationService = FirebaseNotificationService(notiAdapter);
    } else if (notiAdapter is SSENotificationAdapter) {
      __notificationService = SSENotificationService(notiAdapter);
    } else {
      throw UnimplementedError("TODO: Notification: $notiAdapter");
    }
    //
    executionTrace._addTraceStep(
      codeId: "#S0680",
      shortDesc: "Start notificationEngine.",
    );
    //
    // IMPORTANT: No await.
    //
    if (__notificationService != null) {
      print(
          "[FLUTTER_ARTIST] ${getClassNameWithoutGenerics(__notificationService)}.initialize()");
      __notificationService.initialize();
    }
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
    if (isOverlayOpen) {
      return;
    }
    _runWithOverlay(
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

  Future<void> _runWithOverlay({
    required Future<dynamic> Function() asyncFunction,
  }) async {
    await appConfig._overlayAdapter.runWithOverlay(
      opacity: _isOverlayMode ? 0.3 : 0.02,
      asyncFunction: asyncFunction,
    );
  }

  bool get isOverlayOpen {
    return appConfig._overlayAdapter.isOverlayOpen;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugNetworkInspector() async {
    await appConfig._showDebugNetworkInspector(FlutterArtistCore.context);
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Show all active components of all shelves.
  Future<void> showDebugUiContextInspector() async {
    Shelf? shelf = storage._recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showDebugUiContextInspector();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugAppInspectorDialog() async {
    BuildContext context = FlutterArtistCore.context;
    //
    await DebugAppInspectorDialog.open(
      context: context,
      shelf: null,
    );
  }

  Future<void> showDebugFaThemeInspector() async {
    BuildContext context = FlutterArtistCore.context;
    await FaThemeInspectorDialog.show(context);
  }

  Future<void> showDebugFaColorsInspector() async {
    BuildContext context = FlutterArtistCore.context;
    await FaColorsInspectorDialog.show(context);
  }

  Future<void> showCodeFlowInspector() async {
    BuildContext context = FlutterArtistCore.context;
    await CodeFlowInspectorDialog.show(context: context);
  }

  Future<void> showDebugShelfStructureInspector() async {
    Shelf? shelf = storage._recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showDebugShelfStructureInspector();
  }

  bool canShowDebugShelfStructureInspector() {
    Shelf? shelf = storage._recentShelf();
    return shelf != null;
  }

  Future<void> showLogViewerDialog({int? logEntryId}) async {
    BuildContext context = FlutterArtistCore.context;
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
