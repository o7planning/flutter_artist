part of '../__precheck.dart';

/// Precheck conditions and failure reasons for enabling a task form.
enum TaskFormEnablePrecheck implements FormEnablePrecheck {
  /// The system is currently busy executing another operation.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form interaction is disabled.",
    details: ["The system is busy."],
  ),

  /// The task does not have an associated form model.
  noForm(
    precheckCode: PrecheckCode.notAllowed,
    message: "No form available.",
    details: ["The task does not have an associated form model."],
  ),

  /// The task is still in pending state and has not loaded initialization data.
  taskInPendingState(
    precheckCode: PrecheckCode.stageInPendingState,
    message: "Form interaction is disabled.",
    details: [
      "The task is still in pending state and has not loaded initialization data."
    ],
  ),

  /// The task data is stale and requires initialization data to be reloaded.
  taskInStaleState(
    precheckCode: PrecheckCode.stageInPendingState,
    message: "Form interaction is disabled.",
    details: ["The task data is stale and requires reloading."],
  ),

  /// The task has already been successfully submitted and its form is locked (read-only).
  taskAlreadySubmitted(
    precheckCode: PrecheckCode.stageAlreadySubmitted,
    message: "Form interaction is disabled.",
    details: [
      "The task has already been successfully submitted. Use Restart to modify again."
    ],
  ),

  /// The form model is in none state.
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Form is inactive.",
    details: ["The form is currently in none state."],
  ),

  /// The form model is in pending state.
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Form is loading.",
    details: ["The form data is currently pending."],
  ),

  /// The form model encountered a fatal initialization error.
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Form error.",
    details: ["The form encountered a fatal error."],
  ),

  /// The form model is in stale state.
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Form is stale.",
    details: ["The form data is outdated and needs refreshing."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const TaskFormEnablePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
