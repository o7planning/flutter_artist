part of '../__precheck.dart';

/// Precheck enumeration for moving backward to the previous active stage in a [Prozess].
enum ProzessMoveToPreviousStagePrecheck implements Precheck {
  /// Operation aborted because the execution engine is currently busy.
  executorIsBusy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot move to previous stage",
    details: ["System is currently busy processing another task."],
  ),

  /// Operation aborted because no viewing stage is currently active.
  noViewingStage(
    precheckCode: PrecheckCode.noViewingStage,
    message: "Cannot move to previous stage",
    details: ["There is no active viewing stage in the prozess."],
  ),

  /// Operation aborted because the viewing stage is already the first active stage.
  noPreviousStage(
    precheckCode: PrecheckCode.noPreviousStage,
    message: "Cannot move to previous stage",
    details: ["You are already at the first active stage of the prozess."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ProzessMoveToPreviousStagePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
