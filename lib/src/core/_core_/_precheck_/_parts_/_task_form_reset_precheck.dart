part of '../__precheck.dart';

/// Precheck enumeration for resetting a [TaskFormModel] within a [Task].
enum TaskFormResetPrecheck implements Precheck {
  /// Operation aborted because the execution engine is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot reset task form",
    details: ["System is currently busy processing another task."],
  ),

  /// Operation aborted because no form model is configured for this task.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Cannot reset task form",
    details: ["No form model is configured for this task."],
  ),

  /// Operation aborted because the task data state is not ready for form operations.
  taskNotReady(
    precheckCode: PrecheckCode.taskNotReady,
    message: "Cannot reset task form",
    details: ["The task has not loaded its initial data yet."],
  ),

  /// Operation aborted because the form data is not loaded yet.
  formDataNotLoaded(
    precheckCode: PrecheckCode.formDataNotLoaded,
    message: "Cannot reset task form",
    details: ["The form data has not been loaded yet."],
  ),

  /// Operation aborted because the form has no unsaved changes.
  formIsNotDirty(
    precheckCode: PrecheckCode.formIsNotDirty,
    message: "Cannot reset task form",
    details: ["The form has no changes to reset."],
  ),

  /// Operation aborted by custom business rule (`isFormResetAllowed() == false`).
  notAllowed(
    precheckCode: PrecheckCode.notAllowed,
    message: "Cannot reset task form",
    details: ["Resetting this task form is not allowed."],
  ),

  /// Operation aborted due to an unexpected error while evaluating permission.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot reset task form",
    details: ["An error occurred while checking form reset permissions."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const TaskFormResetPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
