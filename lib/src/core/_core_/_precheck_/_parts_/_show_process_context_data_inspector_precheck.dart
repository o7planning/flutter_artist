part of '../__precheck.dart';

/// Precheck enumeration for opening the ProzessContextData debug inspector dialog.
enum ShowProzessContextDataInspectorPrecheck implements Precheck {
  /// No context data has been initialized for this Prozess yet.
  noContextData(
    precheckCode: PrecheckCode.noContextData,
    message: "No context data available.",
    details: ["The Prozess has not initialized its context data yet."],
  ),

  /// No authenticated user session is currently active.
  noLoggedInUser(
    precheckCode: PrecheckCode.noLoggedInUser,
    message: "Access denied.",
    details: ["You must be logged in to inspect Prozess context data."],
  ),

  /// The current user does not have system-level privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.userIsNotSystemUser,
    message: "Access denied.",
    details: ["Only system users are allowed to inspect Prozess context data."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowProzessContextDataInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
