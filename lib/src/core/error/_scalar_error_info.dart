import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/_data_state.dart';
import '../enums/_scalar_error_method.dart';

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
