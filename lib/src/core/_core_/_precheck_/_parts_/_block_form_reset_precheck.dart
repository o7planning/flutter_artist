part of '../__precheck.dart';

/// Precheck enumeration for block form reset operations.
enum BlockFormResetPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form reset is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because no form model is configured for this block.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Form reset is disabled.",
    details: ["The block has no form model configured."],
  ),

  /// Operation aborted because the form is not in a dirty state.
  formIsNotDirty(
    precheckCode: PrecheckCode.formIsNotDirty,
    message: "Form reset is disabled.",
    details: ["The form has no unsaved changes to reset."],
  ),

  /// Operation aborted because the form is in a none state.
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Form reset is disabled.",
    details: ["The form is currently in a 'none' state."],
  ),

  /// Operation aborted because the form is in a pending state.
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Form reset is disabled.",
    details: ["The form is currently in a 'pending' state."],
  ),

  /// Operation aborted because the form is in a fatal error state.
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Form reset is disabled.",
    details: ["The form is currently in a fatal error state."],
  ),

  /// Operation aborted because the form is in a stale state.
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Form reset is disabled.",
    details: ["The form is currently in a stale state."],
  ),

  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Form resetting is disabled.",
    details: ["Application business rules do not allow resetting this form."],
  ),

  /// An error occurred while executing the form reset allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Form resetting is disabled.",
    details: ["An error occurred during the form reset permission check."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormResetPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
