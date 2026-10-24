part of '../__precheck.dart';

/// Precheck conditions and failure reasons for reloading a Task's initial data.
enum TaskRestartPrecheck implements Precheck {
  /// The system is currently busy executing another operation.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The application is currently busy.",
    details: ["The system is currently busy executing another operation."],
  ),

  /// Reloading initial data is restricted by the current task configuration.
  reloadRestrictedByConfig(
    precheckCode: PrecheckCode.notAllowed,
    message: "Action not allowed.",
    details: [
      "Reloading initial data on a fresh state is disabled by task configuration."
    ],
  ),

  /// Reloading initial data is restricted because the task has already been successfully submitted.
  restrictedBySubmitted(
    precheckCode: PrecheckCode.notAllowed,
    message: "Action not allowed.",
    details: [
      "The task has already been successfully submitted and multiple submissions are not allowed."
    ],
  ),

  /// Loading initial data is not allowed under the current task state or configuration.
  notAllowed(
    precheckCode: PrecheckCode.notAllowed,
    message: "Action not allowed.",
    details: [
      "Loading initial data is restricted by the current task configuration or state."
    ],
  ),

  /// An error occurred while executing the task load init-data allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Action not allowed.",
    details: [
      "An error occurred during the task load init-data permission check."
    ],
  ),

  /// Custom rule or external restriction prevents loading initial data.
  customNotAllowed(
    precheckCode: PrecheckCode.notAllowed,
    message: "Action not allowed.",
    details: ["Custom check condition returned false."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const TaskRestartPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
