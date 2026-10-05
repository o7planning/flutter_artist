part of '../__precheck.dart';

/// Precheck enumeration for shelf deferred event execution operations.
enum ShelfDeferredEventExecutionPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot execute deferred events",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// The deferred event execution was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Execution cancelled",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShelfDeferredEventExecutionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
