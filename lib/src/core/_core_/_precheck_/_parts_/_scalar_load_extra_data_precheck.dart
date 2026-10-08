part of '../__precheck.dart';

/// Precheck enumeration for scalar load extra data operations.
enum ScalarLoadExtraDataPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Loading extra data is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ScalarLoadExtraDataPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
