part of '../../flutter_artist.dart';

class ScalarErrorInfo {
  final DataState queryDataState;
  final ScalarErrorMethod scalarErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  ScalarErrorInfo({
    required this.queryDataState,
    required this.scalarErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = ErrorUtils.toAppError(error);

  String get errorMessage {
    return error.errorMessage;
  }

  String get methodName {
    return scalarErrorMethod.name;
  }

  ErrorInfo toErrorInfo() {
    return ErrorInfo(
      errorMessage: error.errorMessage,
      errorDetails: error.errorDetails,
      stackTrace: errorStackTrace,
    );
  }
}
