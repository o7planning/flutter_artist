part of '../core.dart';

class _Storage extends _StorageCore {
  late final __freeze = _StorageFreeze(this);
  late final drawerState = _DrawerState(this);
  late final endDrawerState = _EndDrawerState(this);

  late final ui = _StorageUiComponents(storage: this);

  late final _projectionManager = _ProjectionManager(this);
  late final ev = _StorageEventHandler(this);
  final _naturalQueryQueue = _StorageNaturalQueryQueue();

  late final _queuedEventManager = _QueuedEventManager(this);

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  void _init({
    required ExecutionTrace executionTrace,
    required StorageStructure storageStructure,
  }) {
    TraceStep item = executionTrace._addTraceStep(
      codeId: "#SS000",
      shortDesc:
          "${debugObjHtml(storageStructure)}.defineProjectionFamilies().",
      lineFlowType: LineFlowType.controllableCalling,
      tipDocument: TipDocument.projection,
    );
    final List<ProjectionFamily> projectionFamilies =
        storageStructure.defineProjectionFamilies();
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
      shortDesc: "${debugObjHtml(storageStructure)}.registerActivities().",
      lineFlowType: LineFlowType.controllableCalling,
      tipDocument: TipDocument.activity,
    );
    storageStructure.registerActivities();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterActivities
      ..sort();
    //
    item = executionTrace._addTraceStep(
      codeId: "#SS060",
      shortDesc: "${debugObjHtml(storageStructure)}.registerShelves().",
      lineFlowType: LineFlowType.controllableCalling,
      tipDocument: TipDocument.shelf,
    );
    storageStructure.registerShelves();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterShelves..sort();
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
    required Function(BuildContext context)? navigate,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeBackendAction",
      parameters: {
        "action": action,
      },
      navigate: null,
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
        lineFlowType: LineFlowType.debug,
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
      lineFlowType: LineFlowType.addTaskUnit,
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
      lineFlowType: LineFlowType.debug,
    );
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#35100",
        shortDesc: "Calling ${debugObjHtml(action)}.performBackendOperation().",
        lineFlowType: LineFlowType.controllableCalling,
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
      lineFlowType: LineFlowType.emitEvent,
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
      navigate: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // Open Dialog then freeze Shelf Reaction until closed.
  @_RootMethodAnnotation()
  Future<FreezeByDialogResult<V?>>
      openDialogThenFreezeQueuedEventsUntilClosed<V>({
    required Future<V?> Function() openDialog,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "openDialogThenFreezeQueuedEventsUntilClosed",
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    return await __freeze._openDialogThenFreezeQueuedEventsUntilClosed(
      openDialog: openDialog,
      executionTrace: executionTrace,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  Future<void> openDrawerThenFreezeQueuedEventsUntilClosed(
    BuildContext context, {
    bool showSuggestionIfNeed = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openDrawerThenFreezeQueuedEventsUntilClosed',
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    return await __freeze._openDrawerThenFreezeQueuedEventsUntilClosed(
      context,
      executionTrace: executionTrace,
      showSuggestionIfNeed: showSuggestionIfNeed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  Future<void> openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed(
    BuildContext context, {
    bool showSuggestionIfNeed = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed',
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    return await __freeze
        ._openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed(
      context,
      executionTrace: executionTrace,
      showSuggestionIfNeed: showSuggestionIfNeed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugStorageViewerDialog() async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
    //
    await DebugStorageViewerDialog.open(
      context: context,
      shelf: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Show all active components of all shelves.
  Future<void> showDebugFaUiComponentsViewerDialog() async {
    Shelf? shelf = _recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showDebugFaUiComponentsViewerDialog();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void freezeReactionBetweenShelvesOnce() {
    __freeze._freezeReactionBetweenShelvesOnce();
  }
}
