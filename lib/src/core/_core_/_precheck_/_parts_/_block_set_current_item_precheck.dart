part of '../__precheck.dart';

/// Precheck enumeration for block set item as current operations.
enum BlockSetCurrentItemPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot set item as current.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  // Test Cases: [03b]
  /// Operation aborted because no target item was provided.
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Action ignored.",
    details: ["No target item provided."],
  ),

  // Test Cases: [03b]
  /// Operation aborted because the target item is not in the list.
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Action ignored.",
    details: ["The target item is not present in the current list."],
  ),

  // Test Cases: [03b] ??
  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Action ignored.",
    details: [
      "Application business rules do not allow setting this item as current."
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockSetCurrentItemPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
