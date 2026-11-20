part of '../__precheck.dart';

/// Precheck enumeration for [FilterModel.query] and [FilterModel.queryAll] operations.
enum FilterModelQueryPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy
  /// or querying is temporarily locked while patching filter controls.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot execute filter query.",
    details: ["The system executor is currently busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FilterModelQueryPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
