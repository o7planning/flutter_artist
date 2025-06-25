part of '../../flutter_artist.dart';

abstract class _XBase {
  Shelf get shelf;

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

  Future<bool> __showActionConfirmation<A extends BaseAction>({
    required Shelf shelf,
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

  void _handleError({
    required Shelf shelf,
    required String? methodName,
    required Object error,
    required StackTrace stackTrace,
    required bool showSnackBar,
  }) {
    AppException err = ErrorUtils.toAppException(error);
    //
    final String msg;
    if (methodName == null) {
      msg = "Error: ${err.message}";
    } else {
      if (methodName.contains("\\.")) {
        msg = "Call $methodName() error: ${err.details}";
      } else {
        msg = "Call ${getClassName(this)}.$methodName() error: ${err.message}";
      }
    }
    print(msg);
    //
    if (!FlutterArtist.testCaseMode) {
      print(stackTrace);
    }
    //
    FlutterArtist.codeFlowLogger._addError(
      isLibCode: true,
      ownerClassInstance: this,
      error: msg,
    );
    //
    FlutterArtist.errorLogger.addError(
      shelfName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
      message: msg,
      errorDetails: err.details,
      stackTrace: stackTrace,
    );
    //
    if (showSnackBar) {
      showErrorSnackBar(
        message: msg,
        errorDetails: err.details,
      );
    }
  }

  void _handleRestError({
    required Shelf shelf,
    required String methodName,
    required String message,
    required List<String>? errorDetails,
    required bool showSnackBar,
  }) {
    FlutterArtist.errorLogger.addError(
      shelfName: FlutterArtist.storage._getShelfName(shelf.runtimeType),
      message: message,
      errorDetails: errorDetails,
      stackTrace: null,
    );
    FlutterArtist.codeFlowLogger._addError(
      ownerClassInstance: this,
      error: message,
      isLibCode: true,
    );
    String msg = "Call ${getClassName(this)}.$methodName() error: $message";
    print(msg);
    if (showSnackBar) {
      showErrorSnackBar(
        message: msg,
        errorDetails: errorDetails,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  //
  // Ac
  //
  //
  // if (checkBusy && FlutterArtist.executor.isBusy) {
  // return Actionable.no(
  // message: "Item update is disabled because the executor is busy.",
  // );
  // }

  // ***************************************************************************
  // ***************************************************************************

  void _addErrorLogActionable({
    required Actionable actionableFalse,
    required bool showErrSnackBar,
  }) {
    if (!actionableFalse.yes) {
      FlutterArtist.errorLogger.addError(
        shelfName: shelf.name,
        message: actionableFalse.message!,
        errorDetails: null,
        stackTrace: null,
      );
      if (showErrSnackBar) {
        showErrorSnackBar(
          message: actionableFalse.message!,
          errorDetails: null,
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
      return;
    }
    FlutterArtist.adapter.showErrorSnackBar(
      message: message,
      errorDetails: errorDetails,
    );
  }
}
