part of '../__precheck.dart';

/// Precheck enumeration for opening the TaskResultData debug inspector dialog.
enum ShowTaskResultDataInspectorPrecheck implements Precheck {
  /// No result data has been produced by this Task yet.
  noResultData(
    precheckCode: PrecheckCode.noResultData,
    message: "No result data available.",
    details: ["The Task has not produced any result data yet."],
  ),

  /// No authenticated user session is currently active.
  noLoggedInUser(
    precheckCode: PrecheckCode.notAllowed,
    message: "Access denied.",
    details: ["You must be logged in to inspect Task result data."],
  ),

  /// The current user does not have system-level privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.notAllowed,
    message: "Access denied.",
    details: ["Only system users are allowed to inspect Task result data."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowTaskResultDataInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
