part of '../core.dart';

class _Desk extends _DeskCore {
  final _reactionProcessor = _ReactionProcessor();

  @_RootMethodAnnotation()
  @_AppBackendActionAnnotation()
  Future<AppBackendActionResult> executeAppBackendAction({
    required ActionConfirmationType actionConfirmationType,
    required AppBackendAction action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeAppBackendAction",
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
      methodName: "__checkBeforeExecuteAppBackendAction",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<AppBackendActionPrecheck> actionable =
        __checkBeforeExecuteAppBackendAction(
      checkBusy: checkBusyTrue,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#075040",
        prefixShortDesc: '__checkBeforeExecuteAppBackendAction()',
        module: null,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return AppBackendActionResult(
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
      return AppBackendActionResult(
        precheck: AppBackendActionPrecheck.cancelled,
      );
    }
    //
    executionTrace.addExecutionIntent(
      codeId: "#075340",
      owner: FlutterArtist.executor,
      executionIntentType: AppBackendActionIntent,
      suffixShortDesc: "",
    );
    final executionIntent =
        _createAndSetAppExecutionIntentBackendAction(action: action);
    //
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<AppBackendActionPrecheck> __checkBeforeExecuteAppBackendAction({
    required bool checkBusy,
  }) {
    return AppBackendActionPrecheckUtils.checkBeforeExecuteAppBackendAction(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_AppBackendActionAnnotation()
  Future<bool> _unitAppBackendAction({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required AppBackendActionIntent executionIntent,
  }) async {
    ApiResult<void>? result;
    //
    executionTrace.addInfo(
      codeId: "#035000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${executionUnitType.asDebugExecutionUnit()}.",
    );
    final executionUnitResult = executionIntent.resultWrapper._setResult(
      AppBackendActionResult(),
      objectCaller: this,
      methodName: '_unitAppBackendAction',
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
        tipDocument: TipDocument.performAppBackendOperation,
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

  Future<AppBackendActionResult> broadcastAppBackendActionEvents({
    required List<Type> events,
    required bool needToConfirm,
    String? actionInfo,
  }) async {
    AppBackendAction action = BroadcastBackendEventsAction(
      needToConfirm: needToConfirm,
      events: events,
      actionInfo: actionInfo,
    );
    return await executeAppBackendAction(
      actionConfirmationType: ActionConfirmationType.custom,
      action: action,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  AppBackendActionIntent _createAndSetAppExecutionIntentBackendAction({
    required AppBackendAction action,
  }) {
    final executionIntent = AppBackendActionIntent(action: action);
    FlutterArtist._rootQueue
        ._addAppBackendActionExecutionIntent(executionIntent);
    return executionIntent;
  }
}
