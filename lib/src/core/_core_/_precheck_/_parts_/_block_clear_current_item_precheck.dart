part of '../__precheck.dart';

/// Precheck enumeration for block current item clearing operations.
enum BlockClearCurrentItemPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot clear current item.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because there is no active current item to clear.
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Cannot clear current item.",
    details: ["There is no active current item to clear."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockClearCurrentItemPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
