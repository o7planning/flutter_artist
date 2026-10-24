part of '../__precheck.dart';

/// Precheck enumeration for Stage restart operations.
enum StageRestartPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot restart stage.",
    details: ["The system executor is currently busy. Please wait."],
  ),
  noTargetStage(
    precheckCode: PrecheckCode.noTarget,
    message: "Action not allowed",
    details: ["No target stage is currently selected to restart."],
  ),
  notAllowed(
    precheckCode: PrecheckCode.stageRestartRestricted,
    message: "Stage restart disabled.",
    details: ["Restarting this stage is not allowed by current configuration."],
  ),
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Stage restart cancelled.",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;
  @override
  final String message;
  @override
  final List<String>? details;

  const StageRestartPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
