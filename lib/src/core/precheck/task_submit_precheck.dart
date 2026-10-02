import '__chk_code.dart';
import '__precheck.dart';

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
  formInitialDataNotReady(
    precheckCode: PrecheckCode.formInitialDataNotReady,
    message: "Task submission is disabled.",
    details: ["The form initial data is not ready."],
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
