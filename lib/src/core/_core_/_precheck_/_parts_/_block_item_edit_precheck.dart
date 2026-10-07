part of '../__precheck.dart';

/// Precheck enumeration for block item edit/update operations.
enum BlockItemEditPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot edit item",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because no form model is declared for this block.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Cannot edit item",
    details: ["No form model is configured for this block."],
  ),

  /// Operation aborted because no target item was provided or selected.
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Cannot edit item",
    details: ["No target item was provided for editing."],
  ),

  /// Operation aborted because the block is in a 'none' state.
  blockInNoneState(
    precheckCode: PrecheckCode.blockInNoneState,
    message: "Cannot edit item",
    details: ["The block has not been initialized or loaded yet."],
  ),

  /// Operation aborted because the block is in a pending state.
  blockInPendingState(
    precheckCode: PrecheckCode.blockInPendingState,
    message: "Cannot edit item",
    details: ["The block is currently pending data loading."],
  ),

  /// Operation aborted because the block data is stale.
  blockInStaleState(
    precheckCode: PrecheckCode.blockInStaleState,
    message: "Cannot edit item",
    details: ["The block data is outdated. Please refresh before editing."],
  ),

  /// Operation aborted because the form model encountered a fatal error state.
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Cannot edit item",
    details: ["The form model is in a fatal error state."],
  ),

  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Cannot edit item",
    details: ["Application business rules do not allow editing this item."],
  ),

  /// An error occurred while executing the item edit allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot edit item",
    details: ["An error occurred during the edit permission check."],
  ),

  /// The edit operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Edit cancelled",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemEditPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
