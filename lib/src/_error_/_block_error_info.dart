part of '../_fa_core.dart';

class BlockErrorInfo {
  final DataState queryDataState;
  final BlockErrorMethod blockErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  BlockErrorInfo({
    required this.queryDataState,
    required this.blockErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = ErrorUtils.toAppError(error);

  String get errorMessage {
    return error.errorMessage;
  }

  String get methodName {
    return blockErrorMethod.name;
  }

  ErrorInfo toErrorInfo() {
    return ErrorInfo(
      errorMessage: error.errorMessage,
      errorDetails: error.errorDetails,
      stackTrace: errorStackTrace,
    );
  }
}
