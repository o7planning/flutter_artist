part of '../__precheck.dart';


/// Precheck enumeration for moving forward to the next active stage in a [Prozess].
enum ProzessMoveToNextStagePrecheck implements Precheck {
  /// Operation aborted because the execution engine is currently busy.
  executorIsBusy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot move to next stage",
    details: ["System is currently busy processing another task."],
  ),

  /// Operation aborted because no viewing stage is currently active.
  noViewingStage(
    precheckCode: PrecheckCode.noViewingStage,
    message: "Cannot move to next stage",
    details: ["There is no active viewing stage in the prozess."],
  ),

  /// Operation aborted because the viewing stage is already the last active stage.
  noNextStage(
    precheckCode: PrecheckCode.noNextStage,
    message: "Cannot move to next stage",
    details: ["You are already at the last active stage of the prozess."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ProzessMoveToNextStagePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
