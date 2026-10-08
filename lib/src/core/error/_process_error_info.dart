import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/enums/_enums.dart';

class ProzessErrorInfo {
  final ProzessErrorMethod prozessErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  ProzessErrorInfo({
    required this.prozessErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = FaErrorUtils.toAppError(error);

  String get errorMessage => error.errorMessage;

  String get methodName => prozessErrorMethod.name;

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
      other is ProzessErrorInfo &&
          runtimeType == other.runtimeType &&
          prozessErrorMethod == other.prozessErrorMethod &&
          error == other.error;

  @override
  int get hashCode => Object.hash(runtimeType, prozessErrorMethod, error);

  @override
  String toString() =>
      'ProzessErrorInfo(method: $methodName, error: $errorMessage)';
}
