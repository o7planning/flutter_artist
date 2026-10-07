part of '../__precheck.dart';

/// Precheck enumeration for block quick item update operations.
enum BlockQuickItemUpdatePrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Item update is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  // Test Cases: [91b].
  /// Operation aborted because the block is in a pending state.
  blockInPendingState(
    precheckCode: PrecheckCode.blockInPendingState,
    message: "Item update is disabled.",
    details: ["The block is currently in a 'pending' state."],
  ),

  // Test Cases: [91b].
  /// Operation aborted because the block data is stale.
  blockInStaleState(
    precheckCode: PrecheckCode.blockInStaleState,
    message: "Item update is disabled.",
    details: [
      "The block is currently in a 'loadedStale' state. Please refresh before updating."
    ],
  ),

  // Test Cases: [91b].
  /// Operation aborted because the block is in a none state.
  blockInNoneState(
    precheckCode: PrecheckCode.blockInNoneState,
    message: "Item update is disabled.",
    details: ["The block has not been initialized or loaded yet."],
  ),

  // Test Cases: [90b], [91b].
  /// Operation aborted because the target item does not exist in the block's list.
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Not allowed to update the item.",
    details: ["The target item is not present in the current list."],
  ),

  // Test Cases: [90b].
  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allowed to update the item.",
    details: [
      "Application business rules do not allow this item to be updated."
    ],
  ),

  // Test Cases: [90b].
  /// An error occurred while executing the item update allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allowed to update the item.",
    details: ["An error occurred during the item update permission check."],
  ),

  /// Operation aborted because no target item was provided.
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Not allowed to update the item.",
    details: ["The target item is not available."],
  ),

  /// The quick update item operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Quick update item action cancelled.",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickItemUpdatePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
