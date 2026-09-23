import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/block_error_method.dart';

class StageErrorInfo {
  final StageErrorMethod stageErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  StageErrorInfo({
    required this.stageErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = FaErrorUtils.toAppError(error);

  String get errorMessage => error.errorMessage;

  String get methodName => stageErrorMethod.name;

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
      other is StageErrorInfo &&
          runtimeType == other.runtimeType &&
          stageErrorMethod == other.stageErrorMethod &&
          error == other.error;

  @override
  int get hashCode => Object.hash(runtimeType, stageErrorMethod, error);

  @override
  String toString() =>
      'StageErrorInfo(method: $methodName, error: $errorMessage)';
}
