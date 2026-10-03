part of '../core.dart';

abstract class _Core {
  Future<bool> showConfirmDialog({
    required String message,
    String? details,
  }) async {
    BuildContext context = FlutterArtistCore.context;
    bool confirm = await dialogs.showConfirmDialog(
      context: context,
      message: message,
      details: details ?? "",
    );
    return confirm;
  }

  Future<bool> showConfirmDeleteDialog({String? details}) async {
    BuildContext context = FlutterArtistCore.context;
    bool confirm = await dialogs.showConfirmDeleteDialog(
      context: context,
      details: details ?? "",
    );
    return confirm;
  }

  Future<void> showMessageDialog({
    required String message,
    String? details,
    FaMessageType type = FaMessageType.info,
  }) async {
    BuildContext context = FlutterArtistCore.context;
    await dialogs.showMessageDialog(
      context: context,
      message: message,
      details: details ?? "",
      type: type,
    );
  }

  Future<bool> _showActionConfirmation<A extends Action>({
    required Shelf? shelf,
    required DefaultConfirmation defaultConfirmation,
    required CustomConfirmation? customConfirmation,
  }) async {
    BuildContext context = FlutterArtistCore.context;
    //
    if (customConfirmation != null) {
      try {
        return await customConfirmation(context);
      } catch (e, stackTrace) {
        _handleError(
          module: shelf,
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
    required FeatureModule? module,
    required String? methodName,
    required Object error,
    required StackTrace stackTrace,
    required bool showSnackBar,
    required TipDocument? tipDocument,
  }) {
    AppError appError = FaErrorUtils.toAppError(error);
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
      moduleName: FlutterArtist.storage._getShelfName(module.runtimeType),
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
      moduleName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
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
    required ExecutionTrace executionTrace,
    required String traceStepCodeId,
    required String prefixShortDesc,
    required FeatureModule? module,
    required Actionable actionableFalse,
    required bool showErrSnackBar,
    required TipDocument? tipDocument,
  }) {
    if (!actionableFalse.yes) {
      final LogEntry logEntry = FlutterArtist.logger.addError(
        moduleName: module?.name,
        methodName: null,
        errorMessage: actionableFalse.message!,
        errorDetails: actionableFalse.details,
        stackTrace: actionableFalse.errorInfo?.stackTrace,
        tipDocument: tipDocument,
      );
      //
      Precheck? precheck = actionableFalse.errCode;

      if (precheck != null) {
        executionTrace.addInfo(
          codeId: traceStepCodeId,
          shortDesc: "$prefixShortDesc. actionable.precheck: $precheck",
          errorInfo: logEntry.errorInfo,
        );
      } else {
        executionTrace.addInfo(
          codeId: traceStepCodeId,
          shortDesc:
              "$prefixShortDesc. actionable.errorInfo: ${logEntry.errorInfo?.errorMessage}",
          errorInfo: logEntry.errorInfo,
        );
      }
      //
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
    FlutterArtist.appConfig._overlayAdapter.showWarningSnackBar(
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
    FlutterArtist.appConfig._overlayAdapter.showErrorSnackBar(
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
    FlutterArtist.appConfig._overlayAdapter.showErrorSnackBar(
      message: message,
      details: details,
    );
  }

  void showSavedSnackBar() {
    FlutterArtist.appConfig._overlayAdapter.showSavedSnackBar();
  }

  void showDeletedSnackBar({String? customMessage}) {
    FlutterArtist.appConfig._overlayAdapter.showDeletedSnackBar(
      customMessage: customMessage,
    );
  }

  Actionable<ShowFormInfoPrecheck> _internalCanShowFormInfo({
    required BaseFormModel? formModel,
  }) {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    if (formModel == null) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noForm,
      );
    }
    if (loggedInUser == null) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noLoggedInUser,
      );
    }
    if (!loggedInUser.isSystemUser) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.userIsNotSystemUser,
      );
    }
    return Actionable<ShowFormInfoPrecheck>.yes();
  }
}
