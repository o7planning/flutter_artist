part of '../__precheck.dart';

/// Precheck enumeration for showing FormModel debug inspector operations.
enum ShowFormModelInspectorPrecheck implements Precheck {
  /// Operation aborted because no form model is configured.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Cannot show form model inspector",
    details: ["No form model is configured for this component."],
  ),

  /// Operation aborted because no user is currently logged in.
  noLoggedInUser(
    precheckCode: PrecheckCode.noLoggedInUser,
    message: "Cannot show form model inspector",
    details: ["No user is currently logged in. Authentication required."],
  ),

  /// Operation aborted because the logged-in user lacks system privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.userIsNotSystemUser,
    message: "Cannot show form model inspector",
    details: [
      "Insufficient permissions. System user privileges are required to inspect raw form data."
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowFormModelInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
