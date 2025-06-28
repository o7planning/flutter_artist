part of '../../flutter_artist.dart';

class FormErrorInfo {
  final FormActivityType activityType;
  final FormErrorMethod formErrorMethod;
  final Object error;
  final StackTrace errorStackTrace;

  const FormErrorInfo({
    required this.activityType,
    required this.formErrorMethod,
    required this.error,
    required this.errorStackTrace,
  });

  String get errorMessage {
    AppException ex = ErrorUtils.toAppException(error);
    return ex.message;
  }
}
