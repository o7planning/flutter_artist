part of '../core.dart';

abstract class _Core {
  // TODO: Them tham so BuildContext?
  Future<bool> showConfirmDialog({
    required String message,
    String? details,
  }) async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDialog(
      context: context,
      message: message,
      details: details ?? "",
    );
    return confirm;
  }

  // TODO: Them tham so BuildContext?
  Future<bool> showConfirmDeleteDialog({String? details}) async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
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
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
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
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
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
          tipDocument: null,
        );
        return false;
      }
    } else {
      return await defaultConfirmation(context);
    }
  }

  // ***************************************************************************
  // *********** HANDLE WARN ***************************************************
  // ***************************************************************************

  WarningInfo _handleWarning({
    required Shelf? shelf,
    required String? methodName,
    required String warningMessage,
    required StackTrace? stackTrace,
    required bool showSnackBar,
    required TipDocument? tipDocument,
  }) {
    final String msg;
    if (methodName == null) {
      msg = "Warning: $warningMessage";
    } else {
      if (methodName.contains("\\.")) {
        msg = "Call $methodName() warning: $warningMessage";
      } else {
        msg =
            "Call ${getClassNameWithoutGenerics(this)}.$methodName() warning: $warningMessage";
      }
    }
    //
    final LogEntry logEntry = FlutterArtist.logger.addWarning(
      shelfName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
      methodName: methodName,
      warningMessage: msg,
      stackTrace: null,
      tipDocument: tipDocument,
    );
    //
    if (showSnackBar) {
      showWarningSnackBar(
        message: msg,
      );
    }
    return logEntry.warningInfo!;
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
    required TipDocument? tipDocument,
  }) {
    AppError appError = ErrorUtils.toAppError(error);
    StackTrace? st = appError is ApiError ? null : stackTrace;
    //
    final String msg;
    if (methodName == null) {
      msg = appError.errorMessage;
    } else {
      if (methodName.contains("\\.")) {
        msg =
            "The $methodName() method was called with an error:\n${appError.errorMessage}";
      } else {
        msg =
            "The ${getClassNameWithoutGenerics(this)}.$methodName() method was called with an error:\n${appError.errorMessage}";
      }
    }
    print(msg);
    //
    if (!FlutterArtist.testCaseMode && st != null) {
      print(st);
    }
    //
    final LogEntry logEntry = FlutterArtist.logger.addError(
      shelfName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
      methodName: methodName,
      errorMessage: appError.errorMessage,
      errorDetails: appError.errorDetails,
      stackTrace: st,
      tipDocument: tipDocument,
    );
    //
    if (showSnackBar) {
      showErrorSnackBar(
        message: msg,
        errorDetails: appError.errorDetails,
      );
    }
    return logEntry.errorInfo!;
  }

  ErrorInfo _handleRestError({
    required Shelf shelf,
    required String methodName,
    required String message,
    required List<String>? errorDetails,
    required bool showSnackBar,
    required TipDocument? tipDocument,
  }) {
    final String msg;
    if (methodName.contains("\\.")) {
      msg = "Call $methodName() error: $message";
    } else {
      msg =
          "Call ${getClassNameWithoutGenerics(this)}.$methodName() error: $message";
    }
    print(msg);
    //
    final LogEntry logEntry = FlutterArtist.logger.addError(
      shelfName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
      methodName: methodName,
      errorMessage: message,
      errorDetails: errorDetails,
      stackTrace: null,
      tipDocument: tipDocument,
    );
    //
    if (showSnackBar) {
      showErrorSnackBar(
        message: msg,
        errorDetails: errorDetails,
      );
    }
    return logEntry.errorInfo!;
  }

  // ***************************************************************************
  // ***************************************************************************

  ErrorInfo? _addErrorLogActionable({
    required Shelf? shelf,
    required Actionable actionableFalse,
    required bool showErrSnackBar,
    required TipDocument? tipDocument,
  }) {
    if (!actionableFalse.yes) {
      final LogEntry logEntry = FlutterArtist.logger.addError(
        shelfName: shelf?.name,
        methodName: null,
        errorMessage: actionableFalse.message!,
        errorDetails: actionableFalse.details,
        stackTrace: actionableFalse.errorInfo?.stackTrace,
        tipDocument: tipDocument,
      );
      if (showErrSnackBar) {
        showErrorSnackBar(
          message: actionableFalse.message!,
          errorDetails: actionableFalse.details,
        );
      }
      return logEntry.errorInfo!;
    }
    return null;
  }

  // ***************************************************************************
  // *********** HANDLE ERROR **************************************************
  // ***************************************************************************

  void showWarningSnackBar({
    required String message,
  }) {
    if (FlutterArtist.testCaseMode) {
      // return;
    }
    FlutterArtist.coreFeaturesAdapter.showWarningSnackBar(
      message: message,
      details: null,
    );
  }

  void showErrorSnackBar({
    required String message,
    required List<String>? errorDetails,
  }) {
    if (FlutterArtist.testCaseMode) {
      // return;
    }
    FlutterArtist.coreFeaturesAdapter.showErrorSnackBar(
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
    FlutterArtist.coreFeaturesAdapter.showErrorSnackBar(
      message: message,
      details: details,
    );
  }

  void showSavedSnackBar() {
    FlutterArtist.coreFeaturesAdapter.showSavedSnackBar();
  }

  void showDeletedSnackBar({String? customMessage}) {
    FlutterArtist.coreFeaturesAdapter.showDeletedSnackBar(
      customMessage: customMessage,
    );
  }
}
