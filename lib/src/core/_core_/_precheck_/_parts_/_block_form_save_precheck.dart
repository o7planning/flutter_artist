part of '../__precheck.dart';

// Name (OK)
enum BlockFormSavePrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form saving is disabled.",
    details: ["The system is busy."],
  ),
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Form saving is disabled.",
    details: ["The block has no form."],
  ),
  //
  formIsNotDirty(
    precheckCode: PrecheckCode.formIsNotDirty,
    message: "Form saving is disabled.",
    details: ["The form is not dirty."],
  ),
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Task saving is disabled.",
    details: ["The form in none state."],
  ),
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Task saving is disabled.",
    details: ["The form in pending state."],
  ),
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Task saving is disabled.",
    details: ["The form in fatal error state."],
  ),
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Task saving is disabled.",
    details: ["The form in stale state."],
  ),
  formInvalidated(
    precheckCode: PrecheckCode.formInvalidated,
    message: "Form saving is disabled.",
    details: ["The form is invalidated."],
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
