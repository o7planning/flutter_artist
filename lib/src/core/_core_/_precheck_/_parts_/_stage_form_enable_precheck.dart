part of '../__precheck.dart';

enum StageFormEnablePrecheck implements FormEnablePrecheck {
  hostStateNotReadyForForm(
    precheckCode: PrecheckCode.noForm,
    message: "Stage state is not ready for form",
    details: [],
  ),
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Stage has no Form",
    details: [],
  ),
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Stage Form is disabled.",
    details: ["The form in none state."],
  ),
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Stage Form is disabled.",
    details: ["The form in pending state."],
  ),
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Stage Form is disabled.",
    details: ["The form in fatal error state."],
  ),
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Stage Form is disabled.",
    details: ["The form in stale state."],
  ),
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "The Form is disabled.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "The Form is disabled.",
    details: ["The isItemUpdateAllowed() method error."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StageFormEnablePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
