part of '../core.dart';

class _StorageExecutor {
  final _Storage storage;

  // ***************************************************************************
  // ***************************************************************************

  _StorageExecutor(this.storage);

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
      confirm = await storage._showActionConfirmation(
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
      AppError appError = storage._handleError(
        shelf: null,
        methodName: "executeBackgroundAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      backgroundResult._setAppError(
        appError: appError,
        stackTrace: stackTrace,
      );
    }
    return backgroundResult;
  }
}
