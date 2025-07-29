import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/_form_activity_type.dart';
import '../enums/_form_error_method.dart';

class FormErrorInfo {
  final FormActivityType activityType;
  final String? propName;
  final FormErrorMethod formErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  FormErrorInfo({
    required this.activityType,
    required this.propName,
    required this.formErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = ErrorUtils.toAppError(error);

  String get errorMessage {
    return error.errorMessage;
  }

  String get methodName {
    return formErrorMethod.name;
  }

  ErrorInfo toErrorInfo() {
    return ErrorInfo(
      errorMessage: error.errorMessage,
      errorDetails: error.errorDetails,
      stackTrace: errorStackTrace,
    );
  }
}
