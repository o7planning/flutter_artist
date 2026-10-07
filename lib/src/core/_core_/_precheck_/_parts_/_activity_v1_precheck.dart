part of '../__precheck.dart';

enum ActivityV1Precheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not clear scalar.",
    details: ["The executor is busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ActivityV1Precheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
