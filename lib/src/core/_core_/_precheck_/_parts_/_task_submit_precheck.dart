part of '../__precheck.dart';

enum TaskSubmitPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Task submission is disabled.",
    details: ["The system is busy."],
  ),
  taskInPendingState(
    precheckCode: PrecheckCode.taskInPendingState,
    message: "Task submission is disabled.",
    details: [
      "The task is still in pending state and has not loaded initialization data."
    ],
  ),
  taskInStaleState(
    precheckCode: PrecheckCode.taskInStaleState,
    message: "Task submission is disabled.",
    details: [
      "The task is in stale state and requires initialization data to be reloaded."
    ],
  ),
  taskAlreadySubmitted(
    precheckCode: PrecheckCode.taskAlreadySubmitted,
    message: "Task submission is disabled.",
    details: ["The task has already been successfully submitted."],
  ),
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Task submission is disabled.",
    details: ["The form is in none state."],
  ),
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Task submission is disabled.",
    details: ["The form is in pending state."],
  ),
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Task submission is disabled.",
    details: ["The form is in fatal error state."],
  ),
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Task submission is disabled.",
    details: ["The form is in stale state."],
  ),
  formInvalidated(
    precheckCode: PrecheckCode.formInvalidated,
    message: "Task submission is disabled.",
    details: ["The form validation failed."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const TaskSubmitPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
