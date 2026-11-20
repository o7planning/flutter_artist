part of '../core.dart';

class _Storage extends _StorageCore {
  late final desk = _Desk();
  late final ui = _StorageUiComponents(storage: this);

  final _reactionProcessor = _ReactionProcessor();
  late final _projectionManager = _ProjectionManager(this);
  late final eventHelper = _EventHelper(this);
  final _lazyUiComponentTriggerQueue = _LazyUiComponentTriggerQueue();

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  @override
  void collectGarbage() {
    super.collectGarbage();
    desk._collectGarbage();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _init({
    required ExecutionTrace executionTrace,
    required EffectiveAppConfig appConfig,
  }) {
    TraceStep item = executionTrace.addControllableCall(
      codeId: "#SS000",
      caller: appConfig,
      methodName: "projectionFamilies",
      suffixShortDesc: "",
      tipDocument: TipDocument.projection,
    );
    final List<ProjectionFamily> projectionFamilies =
        appConfig.projectionFamilies;
    // This method may throw Fatal Error cause stop app.
    _projectionManager._init(
      executionTrace: executionTrace,
      projectionFamilies: projectionFamilies,
    );
    //
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterProjections
      ..sort();
    item = executionTrace.addControllableCall(
      codeId: "#SS040",
      caller: appConfig,
      methodName: "registerActivities",
      suffixShortDesc: "",
    );
    appConfig._registerActivities();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterActivities
      ..sort();
    //
    item = executionTrace.addControllableCall(
      codeId: "#SS060",
      caller: appConfig,
      methodName: "registerShelves",
      suffixShortDesc: "",
      tipDocument: TipDocument.shelf,
    );
    appConfig._registerShelves();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterShelves..sort();
    //
    item = executionTrace.addControllableCall(
      codeId: "#SS160",
      caller: appConfig,
      methodName: "additionalThemes",
      suffixShortDesc: "",
      tipDocument: TipDocument.theme,
    );
    List<FaTheme> faThemes = appConfig.additionalThemes;
    FaThemeHub.instance.registerAll(faThemes);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isRouteValid(RouteKey routeKey) {
    for (Shelf shelf in activeShelves) {
      Set<FaRouteData> routes = shelf.ui.faRouteDatas;
      for (FaRouteData faRouteData in routes) {
        if (faRouteData.key.id == routeKey.id) {
          print(" --> FOUND routeKey: ${routeKey}");
          return true;
        }
      }
    }
    for (Activity activity in desk.activeActivities) {
      Set<FaRouteData> routes = activity.ui.faRouteDatas;
      for (FaRouteData faRouteData in routes) {
        if (faRouteData.key.id == routeKey.id) {
          print(" --> FOUND routeKey: ${routeKey}");
          return true;
        }
      }
    }
    if (FlutterArtist.isCommonRouteKey(routeKey)) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _logout() {
    _shelfMap.clear();
    desk._logout();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_StorageBackendActionAnnotation()
  Future<StorageBackendActionResult> executeStorageBackendAction({
    required StorageBackendAction action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeStorageBackendAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;

    executionTrace.addNonControllableCall(
      codeId: "#075000",
      caller: this,
      methodName: "__checkBeforeExecuteStorageBackendAction",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<StorageBackendActionPrecheck> actionable =
        __checkBeforeExecuteStorageBackendAction(
      checkBusy: checkBusyTrue,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#075040",
        prefixShortDesc: '__checkBeforeExecuteStorageBackendAction()',
        module: null,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return StorageBackendActionResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: null,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    //
    if (!confirm) {
      return StorageBackendActionResult(
        precheck: StorageBackendActionPrecheck.cancelled,
      );
    }
    //
    executionTrace.addExecutionIntent(
      codeId: "#075340",
      owner: FlutterArtist.executor,
      executionIntentType: StorageBackendActionIntent,
      suffixShortDesc: "",
    );
    final executionIntent =
        _createAndSetStorageExecutionIntentBackendAction(action: action);
    //
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<StorageBackendActionPrecheck>
      __checkBeforeExecuteStorageBackendAction({
    required bool checkBusy,
  }) {
    return StorageBackendActionPrecheckUtils
        .checkBeforeExecuteStorageBackendAction(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<StorageBackendActionPrecheck>
      checkBeforeExecuteStorageBackendAction() {
    return __checkBeforeExecuteStorageBackendAction(
      checkBusy: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_StorageBackendActionAnnotation()
  Future<bool> _unitStorageBackendAction({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required StorageBackendActionIntent executionIntent,
  }) async {
    ApiResult<void>? result;
    //
    executionTrace.addInfo(
      codeId: "#035000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${executionUnitType.asDebugExecutionUnit()}.",
    );
    final executionUnitResult = executionIntent.resultWrapper._setResult(
      StorageBackendActionResult(),
      objectCaller: this,
      methodName: '_unitStorageBackendAction',
    );
    //
    try {
      executionTrace.addControllableCall(
        codeId: "#035100",
        caller: executionIntent.action,
        methodName: "performBackendOperation",
        suffixShortDesc: "",
      );
      //
      result = await executionIntent.action.performBackendOperation();
      // Throw ApiError.
      result.throwIfError();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: null,
        methodName:
            '${getClassName(executionIntent.action)}.performBackendOperation',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.performStorageBackendOperation,
      );
      //
      executionUnitResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      executionTrace.addInfo(
        codeId: "#035200",
        shortDesc:
            "The ${debugObjHtml(executionIntent.action)}.performBackendOperation() method was called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    executionTrace.addBroadcastEvent(
      codeId: "#035300",
      shortDesc: "${debugObjHtml(this)} > Fire event after backend action.",
    );
    _EventDispatcher.broadcastSystemWide(
      eventType: EventType.mix,
      eventDataTypes: executionIntent.action.config.broadcastEvents,
    );
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<StorageBackendActionResult> broadcastStorageBackendActionEvents({
    required List<Type> events,
    required bool needToConfirm,
    String? actionInfo,
  }) async {
    StorageBackendAction action = BroadcastBackendEventsAction(
      needToConfirm: needToConfirm,
      events: events,
      actionInfo: actionInfo,
    );
    return await executeStorageBackendAction(
      action: action,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  StorageBackendActionIntent _createAndSetStorageExecutionIntentBackendAction({
    required StorageBackendAction action,
  }) {
    final executionIntent = StorageBackendActionIntent(action: action);
    FlutterArtist._rootQueue
        ._addStorageBackendActionExecutionIntent(executionIntent);
    return executionIntent;
  }
}
