import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/filter_activity_type.dart';
import '../enums/filter_error_method.dart';

class FilterErrorInfo {
  final FilterActivityType activityType;
  final String? tildeCriterionName;
  final FilterErrorMethod filterErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  FilterErrorInfo({
    required this.activityType,
    required this.tildeCriterionName,
    required this.filterErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = FaErrorUtils.toAppError(error);

  String get errorMessage {
    return error.errorMessage;
  }

  String get methodName {
    return filterErrorMethod.name;
  }

  ErrorInfo toErrorInfo() {
    return ErrorInfo(
      errorMessage: error.errorMessage,
      errorDetails: error.errorDetails,
      stackTrace: errorStackTrace,
    );
  }
}
