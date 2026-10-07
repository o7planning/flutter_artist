part of '../__precheck.dart';

/// Precheck enumeration for task form enable operations.
enum TaskFormEnablePrecheck implements FormEnablePrecheck {
  /// Operation aborted because the task state is not ready for the form.
  hostStateNotReadyForForm(
    precheckCode: PrecheckCode.noForm,
    message: "Task state is not ready for form.",
    details: ["The underlying task state does not permit form interaction."],
  ),

  /// Operation aborted because no form model is configured.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Task has no form.",
    details: ["No form model is configured for this task."],
  ),

  /// Operation aborted because the form is in a none state.
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Task form is disabled.",
    details: ["The form is currently in a 'none' state."],
  ),

  /// Operation aborted because the form is in a pending state.
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Task form is disabled.",
    details: ["The form is currently in a 'pending' state."],
  ),

  /// Operation aborted because the form is in a fatal error state.
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Task form is disabled.",
    details: ["The form is currently in a fatal error state."],
  ),

  /// Operation aborted because the form is in a stale state.
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Task form is disabled.",
    details: ["The form is currently in a stale state."],
  ),

  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "The form is disabled.",
    details: [
      "Application business rules do not allow this item to be updated."
    ],
  ),

  /// An error occurred while executing the allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "The form is disabled.",
    details: ["An error occurred during the permission check."],
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
