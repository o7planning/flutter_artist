part of '../__precheck.dart';

/// Precheck conditions and failure reasons for reloading a Prozess's initial data.
enum ProzessLoadInitDataPrecheck implements Precheck {
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

  const ProzessLoadInitDataPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
