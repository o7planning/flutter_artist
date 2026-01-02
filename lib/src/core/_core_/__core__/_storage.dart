part of '../core.dart';

class _Storage extends _StorageCore {
  late final __freeze = _StorageFreeze(this);
  late final drawerState = _DrawerState(this);
  late final endDrawerState = _EndDrawerState(this);

  late final _polymorphismManager = _PolymorphismManager(this);
  late final ev = _StorageEventHandler(this);
  final _naturalQueryQueue = _StorageNaturalQueryQueue();

  late final _queuedEventManager = _QueuedEventManager(this);

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  void _init({
    required MasterFlowItem masterFlowItem,
    required StorageStructure storageStructure,
  }) {
    try {
      LineFlowItem item = masterFlowItem._addLineFlowItem(
        codeId: "#SS000",
        shortDesc:
            "${debugObjHtml(storageStructure)}.registerPolymorphismFamilies().",
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.polymorphism,
      );
      final List<PolymorphismFamily> polymorphismFamilies =
          storageStructure.registerPolymorphismFamilies();
      // This method may throw Fatal Error cause stop app.
      _polymorphismManager._init(
        masterFlowItem: masterFlowItem,
        polymorphismFamilies: polymorphismFamilies,
      );
      //
      item._extraInfos = FlutterArtist.debugRegister.debugRegisterPolymorphisms
        ..sort();
      item = masterFlowItem._addLineFlowItem(
        codeId: "#SS040",
        shortDesc: "${debugObjHtml(storageStructure)}.registerActivities().",
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.activity,
      );
      storageStructure.registerActivities();
      item._extraInfos = FlutterArtist.debugRegister.debugRegisterActivities
        ..sort();
      //
      item = masterFlowItem._addLineFlowItem(
        codeId: "#SS060",
        shortDesc: "${debugObjHtml(storageStructure)}.registerShelves().",
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.shelf,
      );
      storageStructure.registerShelves();
      item._extraInfos = FlutterArtist.debugRegister.debugRegisterShelves
        ..sort();
    } catch (e) {
      masterFlowItem.printToConsole();
      print("\n\n");
      rethrow;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerItemVariants({required String name}) {
    //
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
  @_StorageSilentActionAnnotation()
  Future<StorageSilentActionResult> executeSilentAction({
    required ActionConfirmationType actionConfirmationType,
    required StorageSilentAction action,
    required Function(BuildContext context)? navigate,
  }) async {
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeSilentAction",
      parameters: {
        "action": action,
      },
      navigate: null,
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#75000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canSilentAction() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<StorageSilentActionPrecheck> actionable =
        __canSilentAction(
      checkBusy: checkBusyTrue,
    );
    //
    if (!actionable.yes) {
      masterFlowItem._addLineFlowItem(
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
      return StorageSilentActionResult(
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
      return StorageSilentActionResult(
        precheck: StorageSilentActionPrecheck.cancelled,
      );
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#75340",
      shortDesc: "Creating <b>_StorageSilentActionTaskUnit</b>.",
      lineFlowType: LineFlowType.addTaskUnit,
    );
    final taskUnit = _StorageSilentActionTaskUnit(
      action: action,
    );
    //
    FlutterArtist._rootQueue._addStorageSilentActionTaskUnit(taskUnit);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<StorageSilentActionPrecheck> __canSilentAction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<StorageSilentActionPrecheck>.no(
        errCode: StorageSilentActionPrecheck.busy,
      );
    }
    //
    return Actionable<StorageSilentActionPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_StorageSilentActionAnnotation()
  Future<bool> _unitSilentAction({
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required StorageSilentAction action,
    required StorageSilentActionResult taskResult,
  }) async {
    ApiResult<void>? result;
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#35000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#35100",
        shortDesc: "Calling ${debugObjHtml(action)}.callApi().",
        lineFlowType: LineFlowType.controllableCalling,
      );
      //
      result = await action.callApi();
      // Throw ApiError.
      result.throwIfError();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.storageCallApi,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#35200",
        shortDesc:
            "The ${debugObjHtml(action)}.callApi() method was called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#35300",
      shortDesc: "${debugObjHtml(this)} > Fire event after silent action.",
      lineFlowType: LineFlowType.fireEvent,
    );
    FlutterArtist.storage.ev._fireEventFromShelfToOtherShelves(
      masterFlowItem: masterFlowItem,
      eventType: EventType.unknown,
      eventShelf: null,
      events: action.config.affectedItemTypes,
    );
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<StorageSilentActionResult> fireSilentEventsAction({
    required List<Event> events,
    required bool needToConfirm,
    String? actionInfo,
  }) async {
    StorageSilentAction action = FireSilentEventsAction(
      needToConfirm: needToConfirm,
      events: events,
      actionInfo: actionInfo,
    );
    return await executeSilentAction(
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
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "openDialogThenFreezeQueuedEventsUntilClosed",
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    return await __freeze._openDialogThenFreezeQueuedEventsUntilClosed(
      openDialog: openDialog,
      masterFlowItem: masterFlowItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  Future<void> openDrawerThenFreezeQueuedEventsUntilClosed(
    BuildContext context, {
    bool showSuggestionIfNeed = true,
  }) async {
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openDrawerThenFreezeQueuedEventsUntilClosed',
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    return await __freeze._openDrawerThenFreezeQueuedEventsUntilClosed(
      context,
      masterFlowItem: masterFlowItem,
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
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed',
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    return await __freeze
        ._openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed(
      context,
      masterFlowItem: masterFlowItem,
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
  Future<void> showDebugFaUIComponentsViewerDialog() async {
    Shelf? shelf =  _recentShelf();
    if (shelf == null) {
      return;
    }
    await shelf.showDebugFaUIComponentsViewerDialog();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void freezeReactionBetweenShelvesOnce() {
    __freeze._freezeReactionBetweenShelvesOnce();
  }
}
