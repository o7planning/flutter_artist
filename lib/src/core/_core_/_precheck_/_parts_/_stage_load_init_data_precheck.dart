part of '../__precheck.dart';

enum StageLoadInitDataPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The Stage load init data is disabled.",
    details: ["The executor is busy."],
  ),
  /// No valid target stage instance was provided for submission.
  noTargetStage(
    precheckCode: PrecheckCode.noTarget,
    message: "The Stage load init data is disabled.",
    details: ["No target stage specified."],
  ),
  /// The target stage is not currently the active viewing stage.
  isNotViewingStage(
    precheckCode: PrecheckCode.invalidTarget,
    message: "The Stage load init data is disabled.",
    details: ["The target stage is not the active viewing stage."],
  ),

  /// The target stage is not the current frontier stage.
  isNotFrontierStage(
    precheckCode: PrecheckCode.invalidTarget,
    message: "The Stage load init data is disabled.",
    details: ["The target stage is not the active frontier stage."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StageLoadInitDataPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
