part of '../__precheck.dart';

/// Precheck enumeration for scalar query operations.
enum ScalarQueryPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot query scalar data",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Cannot query scalar data",
    details: [
      "Application business rules do not allow querying this scalar at the moment."
    ],
  ),

  /// An error occurred while executing the query allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot query scalar data",
    details: ["An error occurred during the query permission check."],
  ),

  /// The query operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Query cancelled",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ScalarQueryPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
