part of '../core.dart';

class _BackgroundExecutor extends _Core {
  _BackgroundExecutor();

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void executeBackgroundAction({
    required BackgroundAction action,
  }) {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeBackgroundAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    __executeBackgroundAction(
      executionTrace: executionTrace,
      action: action,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<BackgroundActionResult> __executeBackgroundAction({
    required ExecutionTrace executionTrace,
    required BackgroundAction action,
  }) async {
    final needToConfirm = action.needToConfirm;

    executionTrace.addInfo(
      codeId: "#61000",
      shortDesc:
          "${debugObjHtml(action)}.needToConfirm = <b>$needToConfirm<b>.",
    );
    //
    // Confirmation:
    //
    bool confirm = true;
    if (needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: null,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      executionTrace.addInfo(
        codeId: "#61100",
        shortDesc: "@confirm = <b>$confirm</b> --> cancelled.",
      );
      return BackgroundActionResult(
        precheck: BackgroundActionPrecheck.cancelled,
      );
    }
    BackgroundActionResult backgroundResult = BackgroundActionResult();
    try {
      executionTrace.addControllableCall(
        codeId: "#61200",
        caller: action,
        methodName: "run",
        suffixShortDesc: "",
      );
      ApiResult<void> result = await action.run();
      // Throw ApiError:
      result.throwIfError();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "executeBackgroundAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
        tipDocument: TipDocument.backgroundActionRun,
      );
      backgroundResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      executionTrace.addInfo(
        codeId: "#61300",
        shortDesc:
            "The ${debugObjHtml(action)}.run() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
    return backgroundResult;
  }
}
