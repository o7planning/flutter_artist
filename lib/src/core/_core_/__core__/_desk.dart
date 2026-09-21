part of '../core.dart';

class _Desk extends _DeskCore {
  final _reactionProcessor = _ReactionProcessor();

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
    executionTrace.addInfo(
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
      executionTrace.addInfo(
        codeId: "#75040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
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
    executionTrace.addExecutionIntent(
      codeId: "#75340",
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

  @_ExecutionUnitMethodAnnotation()
  @_StorageBackendActionAnnotation()
  Future<bool> _unitBackendAction({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required StorageBackendActionIntent executionIntent,
  }) async {
    ApiResult<void>? result;
    //
    executionTrace.addInfo(
      codeId: "#35000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${executionUnitType.asDebugExecutionUnit()}.",
    );
    final executionUnitResult = executionIntent.resultWrapper._setResult(
      StorageBackendActionResult(),
      objectCaller: this,
      methodName: '_unitBackendAction',
    );
    //
    try {
      executionTrace.addControllableCall(
        codeId: "#35100",
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
        shelf: null,
        methodName:
            '${getClassName(executionIntent.action)}.performBackendOperation',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.storagePerformAction,
      );
      //
      executionUnitResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      executionTrace.addInfo(
        codeId: "#35200",
        shortDesc:
            "The ${debugObjHtml(executionIntent.action)}.performBackendOperation() method was called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    executionTrace.addBroadcastEvent(
      codeId: "#35300",
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

  Future<StorageBackendActionResult> broadcastBackendActionEvents({
    required List<Type> events,
    required bool needToConfirm,
    String? actionInfo,
  }) async {
    StorageBackendAction action = BroadcastBackendEventsAction(
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

  StorageBackendActionIntent _createAndSetStorageExecutionIntentBackendAction({
    required StorageBackendAction action,
  }) {
    final executionIntent = StorageBackendActionIntent(action: action);
    FlutterArtist._rootQueue
        ._addStorageBackendActionExecutionIntent(executionIntent);
    return executionIntent;
  }
}
