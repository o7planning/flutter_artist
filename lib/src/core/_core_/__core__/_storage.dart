part of '../core.dart';

class _Storage extends _StorageCore {
  late final _StorageFreeze __freeze = _StorageFreeze(this);
  late final drawerState = _DrawerState(this);
  late final endDrawerState = _EndDrawerState(this);

  late final _StoragePolymorphismManager _polymorphismManager =
      _StoragePolymorphismManager(this);
  late final _StorageEventHandler ev = _StorageEventHandler(this);
  final _StockersManager _stockersManager = _StockersManager();
  final _StorageNaturalQueryQueue _naturalQueryQueue =
      _StorageNaturalQueryQueue();

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  void _initStorage(StorageStructure storageStructure) {
    storageStructure.registerShelves();
    storageStructure.registerAutoStockers();
    storageStructure.registerPolymorphismFamilies();
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerItemVariants({required String name}) {
    //
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerAutoStocker<F extends AutoStocker<Object, Identifiable<Object>>>(
    StockerCreator<F> builder,
  ) {
    if (__started) {
      // LOGIC: #0001
      throw DebugUtils.getFatalError(
        " ERROR: It is not possible to register a new AutoStocker after the application has been started.",
      );
    }
    _stockersManager._registerAutoStocker(builder);
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
    // FlutterArtist.codeFlowLogger._addMethodCall(
    //   isLibCode: true,
    //   navigate: null,
    //   ownerClassInstance: this,
    //   methodName: "executeSilentAction",
    //   parameters: {
    //     "action": action,
    //   },
    // );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<StorageSilentActionPrecheck> actionable =
        __canSilentAction(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: null,
        actionableFalse: actionable,
        showErrSnackBar: true,
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
    required StorageSilentAction action,
    required StorageSilentActionResult taskResult,
  }) async {
    ApiResult<void>? result;
    try {
      // FlutterArtist.codeFlowLogger._addMethodCall(
      //   ownerClassInstance: action,
      //   methodName: "callApi",
      //   parameters: null,
      //   navigate: null,
      //   isLibCode: false,
      // );
      //
      result = await action.callApi();
      // Throw ApiError.
      result.throwIfError();
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    FlutterArtist.storage.ev._fireEventFromShelfToOtherShelves(
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
      openDialogThenFreezeReactionBetweenShelvesUntilClosed<V>({
    required Future<V?> Function() openDialog,
  }) async {
    return await __freeze
        ._openDialogThenFreezeReactionBetweenShelvesUntilClosed(
      openDialog: openDialog,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  Future<void> openDrawerThenFreezeReactionBetweenShelvesUntilClosed(
    BuildContext context, {
    bool showSuggestionIfNeed = true,
  }) async {
    return await __freeze
        ._openDrawerThenFreezeReactionBetweenShelvesUntilClosed(
      context,
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
    return await __freeze
        ._openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed(
      context,
      showSuggestionIfNeed: showSuggestionIfNeed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void freezeReactionBetweenShelvesOnce() {
    __freeze._freezeReactionBetweenShelvesOnce();
  }
}
