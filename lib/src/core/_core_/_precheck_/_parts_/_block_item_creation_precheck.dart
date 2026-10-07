part of '../__precheck.dart';

@RenameAnnotation()

/// Precheck enumeration for block item creation operations via form.
enum BlockItemCreationPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "New item creation is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  // Test Cases: [01a]
  /// Operation aborted because no form model is configured for this block.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "New item creation is disabled.",
    details: ["No form model is configured for this block."],
  ),

  // Test Cases: [01b]
  /// Operation aborted because the block is in a pending state.
  blockInPendingState(
    precheckCode: PrecheckCode.blockInPendingState,
    message: "New item creation is disabled.",
    details: ["The block is currently in a 'pending' state."],
  ),

  // Test Cases: [01b]
  /// Operation aborted because the block data is stale.
  blockInStaleState(
    precheckCode: PrecheckCode.blockInStaleState,
    message: "New item creation is disabled.",
    details: ["The block data is outdated. Please refresh before creating."],
  ),

  // Test Cases: [01a]
  /// Operation aborted because the block is in a none state.
  blockInNoneState(
    precheckCode: PrecheckCode.blockInNoneState,
    message: "New item creation is disabled.",
    details: ["The block has not been initialized or loaded yet."],
  ),

  // Test Cases: [01a]
  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allowed to create item.",
    details: ["Application business rules do not allow creating a new item."],
  ),

  // Test Cases: [01a]
  /// An error occurred while executing the item creation allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allowed to create item.",
    details: ["An error occurred during the item creation permission check."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemCreationPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
