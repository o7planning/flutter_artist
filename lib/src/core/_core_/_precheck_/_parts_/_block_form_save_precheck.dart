part of '../__precheck.dart';

/// Precheck enumeration for block form save operations.
enum BlockFormSavePrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form saving is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because no form model is configured for this block.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Form saving is disabled.",
    details: ["The block has no form model configured."],
  ),

  /// Operation aborted because the form is not in a dirty state.
  formIsNotDirty(
    precheckCode: PrecheckCode.formIsNotDirty,
    message: "Form saving is disabled.",
    details: ["The form has no changes to save."],
  ),

  /// Operation aborted because the form is in a none state.
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Form saving is disabled.",
    details: ["The form is currently in a 'none' state."],
  ),

  /// Operation aborted because the form is in a pending state.
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Form saving is disabled.",
    details: ["The form is currently in a 'pending' state."],
  ),

  /// Operation aborted because the form is in a fatal error state.
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Form saving is disabled.",
    details: ["The form is currently in a fatal error state."],
  ),

  /// Operation aborted because the form is in a stale state.
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Form saving is disabled.",
    details: ["The form is currently in a stale state."],
  ),

  /// Operation aborted because form validation failed.
  formInvalidated(
    precheckCode: PrecheckCode.formInvalidated,
    message: "Form saving is disabled.",
    details: [
      "The form contains invalid fields. Please correct them before saving."
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormSavePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
