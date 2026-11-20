part of '../__precheck.dart';

/// Precheck enumeration for opening the ProzessInitData debug inspector dialog.
enum ShowProzessInitDataInspectorPrecheck implements Precheck {
  /// No initial data has been loaded for this Prozess yet.
  noInitData(
    precheckCode: PrecheckCode.noInitData,
    message: "No init data available.",
    details: ["The Prozess has not loaded its initial data yet."],
  ),

  /// No authenticated user session is currently active.
  noLoggedInUser(
    precheckCode: PrecheckCode.noLoggedInUser,
    message: "Access denied.",
    details: ["You must be logged in to inspect Prozess init data."],
  ),

  /// The current user does not have system-level privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.userIsNotSystemUser,
    message: "Access denied.",
    details: ["Only system users are allowed to inspect Prozess init data."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowProzessInitDataInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
