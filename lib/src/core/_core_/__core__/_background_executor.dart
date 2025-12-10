part of '../core.dart';

class _BackgroundExecutor extends _Core {
  _BackgroundExecutor();

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void executeBackgroundAction({
    required BackgroundAction action,
  }) {
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeBackgroundAction",
      parameters: {
        "action": action,
      },
      navigate: null,
      isLibMethod: true,
    );
    __executeBackgroundAction(
      masterFlowItem: masterFlowItem,
      action: action,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<BackgroundActionResult> __executeBackgroundAction({
    required MasterFlowItem masterFlowItem,
    required BackgroundAction action,
  }) async {
    final needToConfirm = action.needToConfirm;

    masterFlowItem._addLineFlowItem(
      codeId: "#61000",
      shortDesc:
          "${debugObjHtml(action)}.needToConfirm = <b>$needToConfirm<b>.",
      lineFlowType: LineFlowType.debug,
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
      masterFlowItem._addLineFlowItem(
        codeId: "#61100",
        shortDesc: "@confirm = <b>$confirm</b> --> cancelled.",
      );
      return BackgroundActionResult(
        precheck: BackgroundActionPrecheck.cancelled,
      );
    }
    BackgroundActionResult backgroundResult = BackgroundActionResult();
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#61200",
        shortDesc: "Calling ${debugObjHtml(action)}.run()...",
        lineFlowType: LineFlowType.controllableCalling,
      );
      ApiResult<void> result = await action.run();
      // Throw ApiError:
      result.throwIfError();
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "executeBackgroundAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      backgroundResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#61300",
        shortDesc:
            "The ${debugObjHtml(action)}.run() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
    return backgroundResult;
  }
}
