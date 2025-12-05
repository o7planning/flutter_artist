part of '../core.dart';

abstract class _Core {
  // TODO: Them tham so BuildContext?
  Future<bool> showConfirmDialog({
    required String message,
    String? details,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDialog(
      context: context,
      message: message,
      details: details ?? "",
    );
    return confirm;
  }

  // TODO: Them tham so BuildContext?
  Future<bool> showConfirmDeleteDialog({String? details}) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDeleteDialog(
      context: context,
      details: details ?? "",
    );
    return confirm;
  }

  // TODO: Them tham so BuildContext?
  Future<void> showMessageDialog({
    required String message,
    String? details,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await dialogs.showMessageDialog(
      context: context,
      message: message,
      details: details ?? "",
    );
  }

  Future<bool> _showActionConfirmation<A extends Action>({
    required Shelf? shelf,
    required DefaultConfirmation defaultConfirmation,
    required CustomConfirmation? customConfirmation,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    if (customConfirmation != null) {
      try {
        return await customConfirmation(context);
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "customConfirmation",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        return false;
      }
    } else {
      return await defaultConfirmation(context);
    }
  }

  // ***************************************************************************
  // *********** HANDLE ERROR **************************************************
  // ***************************************************************************

  ErrorInfo _handleError({
    required Shelf? shelf,
    required String? methodName,
    required Object error,
    required StackTrace stackTrace,
    required bool showSnackBar,
  }) {
    AppError appError = ErrorUtils.toAppError(error);
    StackTrace? st = appError is ApiError ? null : stackTrace;
    //
    final String msg;
    if (methodName == null) {
      msg = "Error: ${appError.errorMessage}";
    } else {
      if (methodName.contains("\\.")) {
        msg = "Call $methodName() error: ${appError.errorMessage}";
      } else {
        msg =
            "Call ${getClassNameWithoutGenerics(this)}.$methodName() error: ${appError.errorMessage}";
      }
    }
    print(msg);
    //
    if (!FlutterArtist.testCaseMode && st != null) {
      print(st);
    }
    //
    LogErrorInfo errorInfo = FlutterArtist.errorLogger.addError(
      shelfName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
      methodName: methodName,
      errorMessage: appError.errorMessage,
      errorDetails: appError.errorDetails,
      stackTrace: st,
    );
    //
    if (showSnackBar) {
      showErrorSnackBar(
        message: msg,
        errorDetails: appError.errorDetails,
      );
    }
    return errorInfo;
  }

  ErrorInfo _handleRestError({
    required Shelf shelf,
    required String methodName,
    required String message,
    required List<String>? errorDetails,
    required bool showSnackBar,
  }) {
    final String msg;
    if (methodName == null) {
      msg = "Error: $message";
    } else {
      if (methodName.contains("\\.")) {
        msg = "Call $methodName() error: $message";
      } else {
        msg =
            "Call ${getClassNameWithoutGenerics(this)}.$methodName() error: $message";
      }
    }
    print(msg);
    //
    LogErrorInfo errorInfo = FlutterArtist.errorLogger.addError(
      shelfName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
      methodName: methodName,
      errorMessage: message,
      errorDetails: errorDetails,
      stackTrace: null,
    );
    //
    if (showSnackBar) {
      showErrorSnackBar(
        message: msg,
        errorDetails: errorDetails,
      );
    }
    return errorInfo;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addErrorLogActionable({
    required Shelf? shelf,
    required Actionable actionableFalse,
    required bool showErrSnackBar,
  }) {
    if (!actionableFalse.yes) {
      FlutterArtist.errorLogger.addError(
        shelfName: shelf?.name,
        methodName: null,
        errorMessage: actionableFalse.message!,
        errorDetails: actionableFalse.details,
        stackTrace: actionableFalse.errorInfo?.stackTrace,
      );
      if (showErrSnackBar) {
        showErrorSnackBar(
          message: actionableFalse.message!,
          errorDetails: actionableFalse.details,
        );
      }
    }
  }

  // ***************************************************************************
  // *********** HANDLE ERROR **************************************************
  // ***************************************************************************

  void showErrorSnackBar({
    required String message,
    required List<String>? errorDetails,
  }) {
    if (FlutterArtist.testCaseMode) {
      // return;
    }
    FlutterArtist.adapter.showErrorSnackBar(
      message: message,
      details: errorDetails,
    );
  }

  void showMessageSnackBar({
    required String message,
    required List<String>? details,
  }) {
    if (FlutterArtist.testCaseMode) {
      return;
    }
    FlutterArtist.adapter.showErrorSnackBar(
      message: message,
      details: details,
    );
  }

  void showSavedSnackBar() {
    FlutterArtist.adapter.showSavedSnackBar();
  }

  void showDeletedSnackBar({String? customMessage}) {
    FlutterArtist.adapter.showDeletedSnackBar(
      customMessage: customMessage,
    );
  }
}
