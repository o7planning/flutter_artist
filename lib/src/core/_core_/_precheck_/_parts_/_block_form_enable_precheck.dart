part of '../__precheck.dart';

enum BlockFormEnablePrecheck implements FormEnablePrecheck {
  hostStateNotReadyForForm(
    precheckCode: PrecheckCode.noForm,
    message: "Block state is not ready for form",
    details: [],
  ),
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Block has no Form",
    details: [],
  ),
  // formInNoneMode(
  //   precheckCode: PrecheckCode.inNoneMode,
  //   message: "The Form is disabled",
  //   details: ["The form in 'none' mode"],
  // ),
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Task Form is disabled.",
    details: ["The form in none state."],
  ),
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Task Form is disabled.",
    details: ["The form in pending state."],
  ),
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Task Form is disabled.",
    details: ["The form in fatal error state."],
  ),
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Task Form is disabled.",
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

  const BlockFormEnablePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
