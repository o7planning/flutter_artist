part of '../__precheck.dart';

/// Precheck enumeration for navigating a [Prozess] directly to a target stage.
enum ProzessMoveToStagePrecheck implements Precheck {
  /// The global executor is currently busy executing another unit of work.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "System is busy.",
    details: ["Please wait until the current operation completes."],
  ),

  /// The target stage is not part of the current active workflow route.
  stageNotInActiveRoute(
    precheckCode: PrecheckCode.stageNotInActiveRoute,
    message: "Stage is not in the active route.",
    details: [
      "The target stage has not been reached or was bypassed in the current workflow path.",
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ProzessMoveToStagePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
