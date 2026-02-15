import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/_data_state.dart';
import '../enums/_filter_activity_type.dart';
import '../enums/_filter_error_method.dart';

class FilterErrorInfo {
  final FilterActivityType activityType;
  final String? tildeCriterionName;
  final DataState filterDataState;
  final FilterErrorMethod filterErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  FilterErrorInfo({
    required this.activityType,
    required this.tildeCriterionName,
    required this.filterDataState,
    required this.filterErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = ErrorUtils.toAppError(error);

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
