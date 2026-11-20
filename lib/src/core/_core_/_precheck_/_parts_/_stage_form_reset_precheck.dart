part of '../__precheck.dart';

/// Precheck enumeration for resetting a [StageFormModel] within a [Stage].
enum StageFormResetPrecheck implements Precheck {
  /// Operation aborted because the execution engine is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot reset stage form",
    details: ["System is currently busy processing another task."],
  ),

  /// Operation aborted because no viewing stage is currently active.
  noViewingStage(
    precheckCode: PrecheckCode.noViewingStage,
    message: "Cannot reset stage form",
    details: ["There is no active viewing stage in the prozess."],
  ),

  /// Operation aborted because the target stage is not the currently viewing stage.
  isNotViewingStage(
    precheckCode: PrecheckCode.isNotViewingStage,
    message: "Cannot reset stage form",
    details: ["You can only reset the form of the currently viewing stage."],
  ),

  /// Operation aborted because no form model is configured for this stage.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Cannot reset stage form",
    details: ["No form model is configured for this stage."],
  ),

  /// Operation aborted because the stage data state is not ready for form operations.
  stageNotReady(
    precheckCode: PrecheckCode.stageNotReady,
    message: "Cannot reset stage form",
    details: ["The stage has not loaded its initial data yet."],
  ),

  /// Operation aborted because the form data is not loaded yet.
  formDataNotLoaded(
    precheckCode: PrecheckCode.formDataNotLoaded,
    message: "Cannot reset stage form",
    details: ["The form data has not been loaded yet."],
  ),

  /// Operation aborted because the form has no unsaved changes.
  formIsNotDirty(
    precheckCode: PrecheckCode.formIsNotDirty,
    message: "Cannot reset stage form",
    details: ["The form has no changes to reset."],
  ),

  /// Operation aborted by custom business rule (`isFormResetAllowed() == false`).
  notAllowed(
    precheckCode: PrecheckCode.notAllowed,
    message: "Cannot reset stage form",
    details: ["Resetting this stage form is not allowed."],
  ),

  /// Operation aborted due to an unexpected error while evaluating permission.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot reset stage form",
    details: ["An error occurred while checking form reset permissions."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StageFormResetPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
