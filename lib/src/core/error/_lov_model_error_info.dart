import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/_enums_/_enums.dart';

class LovModelErrorInfo {
  final LovModelErrorMethod lovModelErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  LovModelErrorInfo({
    required this.lovModelErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = FaErrorUtils.toAppError(error);

  String get errorMessage => error.errorMessage;

  String get methodName => lovModelErrorMethod.name;

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
      other is LovModelErrorInfo &&
          runtimeType == other.runtimeType &&
          lovModelErrorMethod == other.lovModelErrorMethod &&
          error == other.error;

  @override
  int get hashCode => Object.hash(runtimeType, lovModelErrorMethod, error);

  @override
  String toString() =>
      'LovModelErrorInfo(method: $methodName, error: $errorMessage)';
}
