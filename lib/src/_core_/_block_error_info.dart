part of '../../flutter_artist.dart';

class BlockErrorInfo {
  final String? propName;
  final Object error;
  final StackTrace errorStackTrace;

  AppError? _appError;

  BlockErrorInfo({
    required this.propName,
    required this.error,
    required this.errorStackTrace,
  });

  AppError _toAppError() {
    _appError ??= ErrorUtils.toAppError(error);
    return _appError!;
  }

  String get errorMessage {
    AppError ae = _toAppError();
    return ae.errorMessage;
  }

  ErrorInfo toErrorInfo() {
    AppError ae = _toAppError();
    return ErrorInfo(
      errorMessage: errorMessage,
      errorDetails: ae.errorDetails,
      stackTrace: errorStackTrace,
    );
  }
}
