part of '../flutter_artist.dart';

abstract class _XBase {



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

  Future<bool> showConfirmDeleteDialog({String? details}) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDeleteDialog(
      context: context,
      details: details ?? "",
    );
    return confirm;
  }

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


  void _handleError({
    required Shelf shelf,
    required String methodName,
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
    String msg =
        "Call ${getClassName(this)}.$methodName() error: ${apiError.errorMessage}";
    print(msg);
    print(stackTrace);
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


  Future<bool> __showDefaultConfirmDialogForAction(
      BaseActionData action,
      ) async {
    return await showConfirmDialog(
      message: 'Are you sure you want to perform this action?',
      details: action.actionInfo,
    );
  }

  Future<bool> __showConfirmDialogForQuickAction<A extends BaseActionData>({
    required  Shelf shelf,
    required A actionData,
    required CustomConfirmation<A>? customConfirmation,
  }) async {
    if (!actionData.needToConfirm) {
      return true;
    }
    final CustomConfirmation<A> confirmForAction =
        customConfirmation ?? __showDefaultConfirmDialogForAction;
    //
    try {
      return await confirmForAction(actionData);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "confirmForAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  void showErrorSnackBar({
    required String message,
    required List<String>? errorDetails,
  }) {
    FlutterArtist.adapter.showErrorSnackBar(
      message: message,
      errorDetails: errorDetails,
    );
  }
}
