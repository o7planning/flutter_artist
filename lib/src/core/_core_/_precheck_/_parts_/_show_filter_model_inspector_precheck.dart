part of '../__precheck.dart';

/// Precheck enumeration for showing full FilterModel debug inspector operations.
enum ShowFilterModelInspectorPrecheck implements Precheck {
  /// Operation aborted because no filter model is configured.
  noFilterModel(
    precheckCode: PrecheckCode.noFilterModel,
    message: "Cannot show filter model inspector",
    details: ["No filter model is configured for this component."],
  ),

  /// Operation aborted because no user is currently logged in.
  noLoggedInUser(
    precheckCode: PrecheckCode.noLoggedInUser,
    message: "Cannot show filter model inspector",
    details: ["No user is currently logged in. Authentication required."],
  ),

  /// Operation aborted because the logged-in user lacks system privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.userIsNotSystemUser,
    message: "Cannot show filter model inspector",
    details: [
      "Insufficient permissions. System user privileges are required to inspect the FilterModel."
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowFilterModelInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
