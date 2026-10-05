part of '../__precheck.dart';

/// Precheck enumeration for multi-item block deletion operations.
enum BlockItemsDeletionPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot delete items",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation not allowed by application business rules for one or more items.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Cannot delete items",
    details: [
      "Application business rules do not allow deleting one or more selected items."
    ],
  ),

  /// An error occurred while executing the multi-item deletion allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot delete items",
    details: ["An error occurred during the deletion permission check."],
  ),

  /// One or more target items do not exist within the current block.
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Deletion ignored",
    details: [
      "One or more target items could not be found in the current block."
    ],
  ),

  /// No target items were provided for deletion.
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Deletion ignored",
    details: ["No target items were provided for deletion."],
  ),

  /// The multi-item deletion operation was cancelled by the user.
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

  const BlockItemsDeletionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
