part of '../__precheck.dart';

enum TaskLoadInitDataPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The Task execution is disabled.",
    details: ["The executor is busy."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const TaskLoadInitDataPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
