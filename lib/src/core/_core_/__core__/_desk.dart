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
      shortDesc: "Creating <b>_StorageBackendActionExecutionUnit</b>.",
      traceStepType: TraceStepType.addExecutionUnit,
    );
    final executionUnit = _StorageBackendActionExecutionUnit(
      action: action,
    );
    //
    FlutterArtist._rootQueue._addStorageBackendActionExecutionUnit(executionUnit);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    return executionUnit.taskResult;
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
    required StorageBackendAction action,
    required StorageBackendActionResult taskResult,
  }) async {
    ApiResult<void>? result;
    //
    executionTrace._addTraceStep(
      codeId: "#35000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${executionUnitType.asDebugExecutionUnit()}.",
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
      traceStepType: TraceStepType.broadcastEvent,
    );
    _EventDispatcher.broadcastSystemWideProjection(
      eventType: EventType.mix,
      eventDataTypes: action.config.broadcastEvents,
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
}
