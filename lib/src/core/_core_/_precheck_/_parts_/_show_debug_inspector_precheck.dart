part of '../__precheck.dart';

/// Precheck enumeration for opening global debug inspector dialogs.
enum ShowDebugInspectorPrecheck implements Precheck {
  /// No authenticated user session is currently active.
  noLoggedInUser(
    precheckCode: PrecheckCode.noLoggedInUser,
    message: "Access denied.",
    details: ["You must be logged in to access debug inspectors."],
  ),

  /// The current user does not have system-level privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.userIsNotSystemUser,
    message: "Access denied.",
    details: ["Only system users are allowed to access debug inspectors."],
  ),

  /// No active module is currently available for inspection.
  noActiveModule(
    precheckCode: PrecheckCode.noActiveModule,
    message: "No active module found.",
    details: ["There is no active Shelf or Activity on the current screen."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowDebugInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
