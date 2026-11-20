part of '../__precheck.dart';

/// Precheck enumeration for block empty-query operations.
enum BlockQueryEmptyPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy
  /// or querying is temporarily locked by the filter model.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot clear block with empty query.",
    details: ["The system executor is currently busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQueryEmptyPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
