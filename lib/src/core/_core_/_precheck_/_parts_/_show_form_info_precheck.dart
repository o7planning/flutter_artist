part of '../__precheck.dart';

/// Precheck enumeration for showing form debug information operations.
enum ShowFormInfoPrecheck implements Precheck {
  /// Operation aborted because no form model is configured.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Cannot show form info",
    details: ["No form model is configured for this component."],
  ),

  /// Operation aborted because no user is currently logged in.
  noLoggedInUser(
    precheckCode: PrecheckCode.noLoggedInUser,
    message: "Cannot show form info",
    details: ["No user is currently logged in. Authentication required."],
  ),

  /// Operation aborted because the logged-in user lacks system privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.userIsNotSystemUser,
    message: "Cannot show form info",
    details: [
      "Insufficient permissions. System user privileges are required to view raw form data."
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowFormInfoPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
