part of '../__precheck.dart';

/// Precheck enumeration for block clear items operations.
enum BlockClearItemsPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot clear block items",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because the block currently has active UI components displayed.
  hasActiveViews(
    precheckCode: PrecheckCode.hasActiveViews,
    message: "Cannot clear block items",
    details: [
      "The block currently has active UI components displayed. Please use query to refresh instead."
    ],
  ),

  /// The clear operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Clear cancelled",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockClearItemsPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
