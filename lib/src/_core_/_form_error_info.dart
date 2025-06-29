part of '../../flutter_artist.dart';

class FormErrorInfo {
  final FormActivityType activityType;

  final String? propName;
  final FormErrorMethod formErrorMethod;
  final Object error;
  final StackTrace errorStackTrace;

  const FormErrorInfo({
    required this.activityType,
    required this.propName,
    required this.formErrorMethod,
    required this.error,
    required this.errorStackTrace,
  });

  String get errorMessage {
    AppError ex = ErrorUtils.toAppError(error);
    return ex.errorMessage;
  }

  String get methodName {
    return formErrorMethod.name;
  }
}
