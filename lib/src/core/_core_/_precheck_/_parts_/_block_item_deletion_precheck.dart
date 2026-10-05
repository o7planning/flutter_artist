part of '../__precheck.dart';

// Test Cases: [03a].
/// Precheck enumeration for block item deletion operations.
enum BlockItemDeletionPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot delete item",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation not allowed by the application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Cannot delete item",
    details: ["Application business rules do not allow deleting this item."],
  ),

  /// An error occurred while executing the deletion allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot delete item",
    details: ["An error occurred during the deletion permission check."],
  ),

  /// The target item does not exist within the current block.
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Deletion ignored",
    details: ["The target item could not be found in the current block."],
  ),

  /// No target item was provided for deletion.
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Deletion ignored",
    details: ["No target item was provided for deletion."],
  ),

  /// The deletion operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Deletion cancelled",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemDeletionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
