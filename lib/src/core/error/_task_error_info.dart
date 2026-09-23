import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/block_error_method.dart';

class TaskErrorInfo {
  final TaskErrorMethod taskErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  TaskErrorInfo({
    required this.taskErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = FaErrorUtils.toAppError(error);

  String get errorMessage => error.errorMessage;

  String get methodName => taskErrorMethod.name;

  ErrorInfo toErrorInfo() {
    return ErrorInfo(
      errorMessage: error.errorMessage,
      errorDetails: error.errorDetails,
      stackTrace: errorStackTrace,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskErrorInfo &&
          runtimeType == other.runtimeType &&
          taskErrorMethod == other.taskErrorMethod &&
          error == other.error;

  @override
  int get hashCode => Object.hash(runtimeType, taskErrorMethod, error);

  @override
  String toString() =>
      'TaskErrorInfo(method: $methodName, error: $errorMessage)';
}
