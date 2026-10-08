part of '../__precheck.dart';

/// Precheck rules governing whether a [Prozess] is permitted to rewind
/// its frontier back to a target [Stage].
enum StageRewindPrecheck implements Precheck {
  /// The global execution engine is currently busy processing another task.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Stage rewind is disabled.",
    details: ["The system is busy."],
  ),

  /// No valid target stage instance was provided for rewinding.
  noTargetStage(
    precheckCode: PrecheckCode.noTarget,
    message: "Stage rewind is disabled.",
    details: ["No target stage specified for rewinding."],
  ),

  /// Stage re-execution is globally restricted by the prozess configuration.
  reexecutionNotAllowed(
    precheckCode: PrecheckCode.reexecutionNotAllowed,
    message: "Stage rewind is disabled.",
    details: ["Prozess configuration does not permit stage re-execution."],
  ),

  /// The target stage has not yet been successfully submitted.
  stageNotSubmittedYet(
    precheckCode: PrecheckCode.stageNotSubmittedYet,
    message: "Stage rewind is disabled.",
    details: ["The target stage has not been completed or submitted yet."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StageRewindPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
