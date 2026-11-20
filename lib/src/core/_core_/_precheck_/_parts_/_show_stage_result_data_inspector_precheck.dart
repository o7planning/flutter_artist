part of '../__precheck.dart';

/// Precheck enumeration for opening the StageResultData debug inspector dialog.
enum ShowStageResultDataInspectorPrecheck implements Precheck {
  /// No stage is currently being viewed in the Prozess.
  noViewingStage(
    precheckCode: PrecheckCode.noData,
    message: "No viewing stage.",
    details: ["There is no active viewing stage in the Prozess."],
  ),

  /// The stage has not been reached yet in the current workflow path.
  stageUnreached(
    precheckCode: PrecheckCode.noData,
    message: "Stage has not been reached yet.",
    details: [
      "This stage is currently unreached and has not been submitted yet.",
    ],
  ),

  /// The stage was bypassed by the workflow routing logic.
  stageBypassed(
    precheckCode: PrecheckCode.noData,
    message: "Stage was bypassed.",
    details: [
      "This stage was skipped in the current workflow route, so no result data was produced.",
    ],
  ),

  /// The stage is active, but has not been submitted successfully yet.
  noResultData(
    precheckCode: PrecheckCode.noData,
    message: "No result data available.",
    details: [
      "The stage has not produced any result data yet (submission not completed).",
    ],
  ),

  /// No authenticated user session is currently active.
  noLoggedInUser(
    precheckCode: PrecheckCode.notAllowed,
    message: "Access denied.",
    details: ["You must be logged in to inspect Stage result data."],
  ),

  /// The current user does not have system-level privileges.
  userIsNotSystemUser(
    precheckCode: PrecheckCode.notAllowed,
    message: "Access denied.",
    details: ["Only system users are allowed to inspect Stage result data."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowStageResultDataInspectorPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
