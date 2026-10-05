part of '../__precheck.dart';

/// Precheck enumeration for scalar clear operations.
enum ScalarClearPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot clear scalar data",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because the scalar currently has active UI views bound to it.
  hasActiveViews(
    precheckCode: PrecheckCode.hasActiveViews,
    message: "Cannot clear scalar",
    details: [
      "The scalar currently has active UI components displayed. Please use query to refresh instead."
    ],
  ),

  /// The clear operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Clear cancelled",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ScalarClearPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
