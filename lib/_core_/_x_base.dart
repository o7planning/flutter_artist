part of '../flutter_artist.dart';

abstract class _XBase {
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
    required dynamic error,
    required StackTrace stackTrace,
    required bool showSnackBar,
  }) {
    ApiError apiError;
    if (error is ApiError) {
      apiError = error;
    } else {
      apiError = ApiError(
        errorMessage: error.toString(),
        status: null,
        errorDetails: null,
      );
    }
    //
    final String msg;
    if (methodName == null) {
      msg = "Error: ${apiError.errorMessage}";
    } else {
      if (methodName.contains("\\.")) {
        msg = "Call $methodName() error: ${apiError.errorMessage}";
      } else {
        msg =
            "Call ${getClassName(this)}.$methodName() error: ${apiError.errorMessage}";
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
      errorDetails: apiError.errorDetails,
      stackTrace: stackTrace,
    );
    //
    if (showSnackBar) {
      showErrorSnackBar(
        message: msg,
        errorDetails: apiError.errorDetails,
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
