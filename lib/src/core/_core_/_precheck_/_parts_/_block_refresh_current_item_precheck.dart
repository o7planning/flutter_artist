part of '../__precheck.dart';

/// Precheck enumeration for block current item refresh operations.
enum BlockRefreshCurrentItemPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot refresh current item.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because there is no active current item in the block.
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Cannot refresh current item.",
    details: ["There is no current item to refresh."],
  ),

  /// Operation aborted because the current item is no longer present in the list.
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Cannot refresh current item.",
    details: ["The current item is not present in the current list."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockRefreshCurrentItemPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
