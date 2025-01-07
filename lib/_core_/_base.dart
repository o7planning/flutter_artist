part of '../flutter_artist.dart';

abstract class BaseBlk {
  late final Shelf shelf;

  void _handleError({
    required String className,
    required String methodName,
    required dynamic error,
    required StackTrace stackTrace,
    required bool showSnackbar,
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
    String msg =
        "Call $className.$methodName() error: ${apiError.errorMessage}";
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
    print(msg);
    print(stackTrace);
    if (showSnackbar) {
      showErrorSnackbar(
        message: msg,
        errorDetails: apiError.errorDetails,
      );
    }
  }

  void _handleRestError({
    required String methodName,
    required String message,
    required List<String>? errorDetails,
    required bool showSnackbar,
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
    if (showSnackbar) {
      showErrorSnackbar(
        message: msg,
        errorDetails: errorDetails,
      );
    }
  }

  void showErrorSnackbar({
    required String message,
    required List<String>? errorDetails,
  }) {
    FlutterArtist.adapter.showErrorSnackbar(
      message: message,
      errorDetails: errorDetails,
    );
  }
}
