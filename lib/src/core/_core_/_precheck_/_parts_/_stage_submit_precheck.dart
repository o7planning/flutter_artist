part of '../__precheck.dart';

enum StageSubmitPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "System is busy",
    details: ["Please wait while the current operation completes."],
  ),
  noTargetStage(
    precheckCode: PrecheckCode.noTarget,
    message: "Action not allowed",
    details: ["No target stage is currently selected."],
  ),
  isNotViewingStage(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Action not allowed",
    details: ["You can only submit the stage that you are currently viewing."],
  ),
  stageAlreadySubmitted(
    precheckCode: PrecheckCode.stageAlreadySubmitted,
    message: "Stage already completed",
    details: [
      "This step has already been successfully submitted. To make changes, please restart the process from this step."
    ],
  ),
  stageInPendingState(
    precheckCode: PrecheckCode.stageInPendingState,
    message: "Stage is loading",
    details: ["The stage is still loading initialization data. Please wait."],
  ),
  stageInStaleState(
    precheckCode: PrecheckCode.stageInPendingState,
    message: "Data is outdated",
    details: ["The stage data is out of date and requires reloading."],
  ),
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Form is not ready",
    details: ["The form has not been initialized yet."],
  ),
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Form is loading",
    details: ["The form data is still loading."],
  ),
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Form initialization failed",
    details: ["The form encountered a fatal error during initialization."],
  ),
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Form data is outdated",
    details: ["The form data is stale and needs to be refreshed."],
  ),
  formInvalidated(
    precheckCode: PrecheckCode.formInvalidated,
    message: "Validation failed",
    details: [
      "Please correct the highlighted errors in the form before submitting."
    ],
  );

  @override
  final PrecheckCode precheckCode;
  @override
  final String message;
  @override
  final List<String>? details;

  const StageSubmitPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
