part of '../__precheck.dart';

enum StageFormEnablePrecheck implements FormEnablePrecheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form interaction is disabled.",
    details: ["The system is busy."],
  ),
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Stage has no Form",
    details: [],
  ),
  noTargetStage(
    precheckCode: PrecheckCode.noTarget,
    message: "Form interaction is disabled.",
    details: ["No target stage specified."],
  ),
  isNotViewingStage(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Form interaction is disabled.",
    details: ["The target stage is not the active viewing stage."],
  ),
  stageInPendingState(
    precheckCode: PrecheckCode.stageInPendingState,
    message: "Form interaction is disabled.",
    details: ["The stage is still in pending state."],
  ),
  stageInStaleState(
    precheckCode: PrecheckCode.stageInPendingState,
    message: "Form interaction is disabled.",
    details: ["The stage data is stale and requires reloading."],
  ),
  stageAlreadySubmitted(
    precheckCode: PrecheckCode.stageAlreadySubmitted,
    message: "Form interaction is disabled.",
    details: [
      "The stage has already been successfully submitted and is locked."
    ],
  ),
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Stage Form is disabled.",
    details: ["The form is in none state."],
  ),
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Stage Form is disabled.",
    details: ["The form is in pending state."],
  ),
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Stage Form is disabled.",
    details: ["The form is in fatal error state."],
  ),
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Stage Form is disabled.",
    details: ["The form is in stale state."],
  ),
  notAllowed(
    precheckCode: PrecheckCode.notAllowed,
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
