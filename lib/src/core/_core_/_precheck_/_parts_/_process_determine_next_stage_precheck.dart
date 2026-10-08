part of '../__precheck.dart';

enum ProzessDetermineNextStagePrecheck implements Precheck {
  /// The system is currently busy executing another operation.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The application is currently busy.",
    details: ["The system is currently busy executing another operation."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ProzessDetermineNextStagePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
