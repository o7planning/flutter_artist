import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/block_error_method.dart';

class BlockErrorInfo {
  final BlockErrorMethod blockErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;

  BlockErrorInfo({
    required this.blockErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = FaErrorUtils.toAppError(error);

  String get errorMessage => error.errorMessage;

  String get methodName => blockErrorMethod.name;

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
      other is BlockErrorInfo &&
          runtimeType == other.runtimeType &&
          blockErrorMethod == other.blockErrorMethod &&
          error == other.error;

  @override
  int get hashCode => Object.hash(runtimeType, blockErrorMethod, error);

  @override
  String toString() =>
      'BlockErrorInfo(method: $methodName, error: $errorMessage)';
}
