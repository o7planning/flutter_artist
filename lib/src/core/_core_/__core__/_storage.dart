part of '../core.dart';

class _Storage extends _StorageCore {
  late final __deferment = _StorageDeferment(this);
  late final drawer = _DrawerController(this);
  late final endDrawer = _EndDrawerController(this);

  late final ui = _StorageUiComponents(storage: this);

  late final _projectionManager = _ProjectionManager(this);
  late final ev = _StorageEventHandler(this);
  final _naturalQueryQueue = _StorageNaturalQueryQueue();

  late final _deferredEventManager = _DeferredEventManager(this);

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  void _init({
    required ExecutionTrace executionTrace,
    required AppConfiguration appConfiguration,
  }) {
    TraceStep item = executionTrace._addTraceStep(
      codeId: "#SS000",
      shortDesc: "${debugObjHtml(appConfiguration)}.projectionFamilies().",
      traceStepType: TraceStepType.controllableCalling,
      tipDocument: TipDocument.projection,
    );
    final List<ProjectionFamily> projectionFamilies =
        appConfiguration.projectionFamilies();
    // This method may throw Fatal Error cause stop app.
    _projectionManager._init(
      executionTrace: executionTrace,
      projectionFamilies: projectionFamilies,
    );
    //
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterProjections
      ..sort();
    item = executionTrace._addTraceStep(
      codeId: "#SS040",
      shortDesc: "${debugObjHtml(appConfiguration)}.registerActivities().",
      traceStepType: TraceStepType.controllableCalling,
      tipDocument: TipDocument.activity,
    );
    appConfiguration.registerActivities();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterActivities
      ..sort();
    //
    item = executionTrace._addTraceStep(
      codeId: "#SS060",
      shortDesc: "${debugObjHtml(appConfiguration)}.registerShelves().",
      traceStepType: TraceStepType.controllableCalling,
      tipDocument: TipDocument.shelf,
    );
    appConfiguration.registerShelves();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterShelves..sort();
    //
    item = executionTrace._addTraceStep(
      codeId: "#SS160",
      shortDesc: "${debugObjHtml(appConfiguration)}.additionalThemes().",
      traceStepType: TraceStepType.controllableCalling,
      tipDocument: TipDocument.theme,
    );
    List<FaTheme> faThemes = appConfiguration.additionalThemes();
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
    if (FlutterArtist.isCommonRouteKey(routeKey)) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _logout() {
    _shelfMap.clear();
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  @_RootMethodAnnotation()
  @_StorageBackendActionAnnotation()
  Future<StorageBackendActionResult> executeBackendAction({
    required ActionConfirmationType actionConfirmationType,
    required StorageBackendAction action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeBackendAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    //
    executionTrace._addTraceStep(
      codeId: "#75000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canBackendAction() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<StorageBackendActionPrecheck> actionable =
        __canBackendAction(
      checkBusy: checkBusyTrue,
    );
    //
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#75040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: null,
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
    executionTrace._addTraceStep(
      codeId: "#75340",
      shortDesc: "Creating <b>_StorageBackendActionTaskUnit</b>.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    final taskUnit = _StorageBackendActionTaskUnit(
      action: action,
    );
    //
    FlutterArtist._rootQueue._addStorageBackendActionTaskUnit(taskUnit);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<StorageBackendActionPrecheck> __canBackendAction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<StorageBackendActionPrecheck>.no(
        errCode: StorageBackendActionPrecheck.busy,
      );
    }
    //
    return Actionable<StorageBackendActionPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_StorageBackendActionAnnotation()
  Future<bool> _unitBackendAction({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required StorageBackendAction action,
    required StorageBackendActionResult taskResult,
  }) async {
    ApiResult<void>? result;
    //
    executionTrace._addTraceStep(
      codeId: "#35000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      traceStepType: TraceStepType.debug,
    );
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#35100",
        shortDesc: "Calling ${debugObjHtml(action)}.performBackendOperation().",
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      result = await action.performBackendOperation();
      // Throw ApiError.
      result.throwIfError();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: '${getClassName(action)}.performBackendOperation',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.storagePerformAction,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      executionTrace._addTraceStep(
        codeId: "#35200",
        shortDesc:
            "The ${debugObjHtml(action)}.performBackendOperation() method was called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#35300",
      shortDesc: "${debugObjHtml(this)} > Fire event after backend action.",
      traceStepType: TraceStepType.emitEvent,
    );
    FlutterArtist.storage.ev._emitEventFromShelfToOtherShelves(
      executionTrace: executionTrace,
      eventType: EventType.unknown,
      eventShelf: null,
      events: action.config.emitEvents,
    );
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<StorageBackendActionResult> emitBackendActionEvents({
    required List<Event> events,
    required bool needToConfirm,
    String? actionInfo,
  }) async {
    StorageBackendAction action = FireBackendEventsAction(
      needToConfirm: needToConfirm,
      events: events,
      actionInfo: actionInfo,
    );
    return await executeBackendAction(
      actionConfirmationType: ActionConfirmationType.custom,
      action: action,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // openDialogThenFreezeQueuedEventsUntil Closed (OLD)
  // Open Dialog then freeze Shelf Reaction until closed.
  @_RootMethodAnnotation()
  Future<DialogDeferralResult<V?>>
      openDialogAndDeferExternalShelfEventsUntilClosed<V>({
    required Future<V?> Function() openDialog,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "openDialogAndDeferExternalShelfEventsUntilClosed",
      parameters: null,
      isLibMethod: true,
    );
    return await __deferment._openDialogAndDeferExternalShelfEventsUntilClosed(
      openDialog: openDialog,
      executionTrace: executionTrace,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // openDrawerThenFreezeQueuedEventsUntil Closed (OLD)
  @_RootMethodAnnotation()
  Future<void> openDrawerAndDeferExternalShelfEventsUntilClosed(
    BuildContext context, {
    bool showSuggestionIfNeed = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openDrawerAndDeferExternalShelfEventsUntilClosed',
      parameters: null,
      isLibMethod: true,
    );
    return await __deferment._openDrawerAndDeferExternalShelfEventsUntilClosed(
      context,
      executionTrace: executionTrace,
      showSuggestionIfNeed: showSuggestionIfNeed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // openEndDrawerAndFreezeExternalReactions
  // openEndDrawerThenFreezeReactionBetweenShelvesUntil Closed
  @_RootMethodAnnotation()
  Future<void> openEndDrawerAndDeferExternalShelfEventsUntilClosed(
    BuildContext context, {
    bool showSuggestionIfNeed = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openEndDrawerAndDeferExternalShelfEventsUntilClosed',
      parameters: null,
      isLibMethod: true,
    );
    return await __deferment
        ._openEndDrawerAndDeferExternalShelfEventsUntilClosed(
      context,
      executionTrace: executionTrace,
      showSuggestionIfNeed: showSuggestionIfNeed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void freezeReactionBetweenShelvesOnce() {
    __deferment._freezeReactionBetweenShelvesOnce();
  }
}
