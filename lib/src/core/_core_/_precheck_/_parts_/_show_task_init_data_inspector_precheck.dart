part of '../__precheck.dart';

/// Precheck enumeration for opening the TaskInitData debug inspector dialog.
enum ShowTaskInitDataInspectorPrecheck implements Precheck {
  /// No initial data has been loaded for this Task yet.
  noInitData(
    precheckCode: PrecheckCode.noInitData,
    message: "No init data available.",
    details: ["The Task has not loaded its initial data yet."],
  ),

  /// No authenticated user session is currently active.
  noLoggedInUser(
    precheckCode: PrecheckCode.notAllowed,
    message: "Access denied.",
    details: ["You must be logged in to inspect Task init data."],
  ),

  /// The current user does not have system-level privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.notAllowed,
    message: "Access denied.",
    details: ["Only system users are allowed to inspect Task init data."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowTaskInitDataInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
