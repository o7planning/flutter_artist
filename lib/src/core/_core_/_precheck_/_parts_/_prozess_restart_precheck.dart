part of '../__precheck.dart';

// ---------------------------------------------------------------------------

/// Precheck enumeration for Prozess restart operations.
enum ProzessRestartPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot restart process.",
    details: ["The system executor is currently busy. Please wait."],
  ),
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Process restart cancelled.",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;
  @override
  final String message;
  @override
  final List<String>? details;

  const ProzessRestartPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
