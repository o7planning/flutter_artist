part of '../../flutter_artist.dart';

class FormErrorInfo {
  final FormActivityType activityType;

  final String? propName;
  final FormErrorMethod formErrorMethod;
  final Object error;
  final StackTrace errorStackTrace;

  AppError? _appError;

  FormErrorInfo({
    required this.activityType,
    required this.propName,
    required this.formErrorMethod,
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

  String get methodName {
    return formErrorMethod.name;
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
