part of '../core.dart';

class _BackgroundExecutor extends _Core {
  _BackgroundExecutor();

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void executeBackgroundAction({
    required BackgroundAction action,
  }) {
    __executeBackgroundAction(action: action);
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<BackgroundActionResult> __executeBackgroundAction({
    required BackgroundAction action,
  }) async {
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
    if (!confirm) {
      return BackgroundActionResult(
        precheck: BackgroundActionPrecheck.cancelled,
      );
    }
    BackgroundActionResult backgroundResult = BackgroundActionResult();
    try {
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
    }
    return backgroundResult;
  }
}
