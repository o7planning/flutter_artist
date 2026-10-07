part of '../__precheck.dart';

/// Precheck enumeration for block quick item creation operations.
enum BlockQuickItemCreationPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "New item creation is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  // Test Cases: [91a].
  /// Operation aborted because the block is in a pending state.
  blockInPendingState(
    precheckCode: PrecheckCode.blockInPendingState,
    message: "New item creation is disabled.",
    details: ["The block is currently in a 'pending' state."],
  ),

  // Test Cases: [91a].
  /// Operation aborted because the block data is stale.
  blockInStaleState(
    precheckCode: PrecheckCode.blockInStaleState,
    message: "New item creation is disabled.",
    details: [
      "The block is currently in a 'loadedStale' state. Please refresh before creating."
    ],
  ),

  // Test Cases: [91a].
  /// Operation aborted because the block is in a none state.
  blockInNoneState(
    precheckCode: PrecheckCode.blockInNoneState,
    message: "New item creation is disabled.",
    details: ["The block has not been initialized or loaded yet."],
  ),

  // Test Cases: [90b].
  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allowed to create item.",
    details: [
      "Application business rules do not allow creating a new item at the moment."
    ],
  ),

  // Test Cases: [90b].
  /// An error occurred while executing the item creation allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allowed to create item.",
    details: ["An error occurred during the item creation permission check."],
  ),

  // Test Cases: [90b].
  /// The quick create item operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Quick create item action cancelled.",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickItemCreationPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
