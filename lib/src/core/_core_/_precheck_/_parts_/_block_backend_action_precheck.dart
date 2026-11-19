part of '../__precheck.dart';

/// Precheck enumeration for block backend action executions.
enum BlockBackendActionPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Backend action is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation not allowed by application business rules.
  notAllowed(
    precheckCode: PrecheckCode.notAllowed,
    message: "Backend action is not allowed.",
    details: [
      "Application business rules do not allow executing this backend action."
    ],
  ),

  /// An error occurred while executing the backend action allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Backend action is not allowed.",
    details: ["An error occurred during the backend action permission check."],
  ),

  /// Operation aborted because the block is in a pending state.
  blockInPendingState(
    precheckCode: PrecheckCode.blockInPendingState,
    message: "Backend action is disabled.",
    details: ["The block is currently in a 'pending' state."],
  ),

  /// Operation aborted because the block data is stale.
  blockInStaleState(
    precheckCode: PrecheckCode.blockInStaleState,
    message: "Backend action is disabled.",
    details: [
      "The block data is outdated. Please refresh before executing backend actions."
    ],
  ),

  /// Operation aborted because the block is in a none state.
  blockInNoneState(
    precheckCode: PrecheckCode.blockInNoneState,
    message: "Backend action is disabled.",
    details: ["The block has not been initialized or loaded yet."],
  ),

  /// The backend action was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Backend action cancelled.",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockBackendActionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
