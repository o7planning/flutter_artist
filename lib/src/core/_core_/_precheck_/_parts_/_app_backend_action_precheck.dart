part of '../__precheck.dart';

/// Precheck enumeration for application-level backend action executions.
enum AppBackendActionPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Backend action is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// The application backend action was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Backend action cancelled.",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const AppBackendActionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
