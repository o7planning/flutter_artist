part of '../__precheck.dart';

/// Precheck enumeration for LOV query operations.
enum LovQueryPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot query LOV data",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation not allowed by application business rules.
  notAllowed(
    precheckCode: PrecheckCode.notAllowed,
    message: "Cannot query LOV data",
    details: [
      "Application business rules do not allow querying this LOV at the moment."
    ],
  ),

  /// Pagination operations (next/previous/more page) are not supported
  /// because the LOV is configured in full-query mode.
  pageableNotSupported(
    precheckCode: PrecheckCode.pageableNotSupported,
    message: "Cannot paginate",
    details: ["Pagination is not supported under the current full-query mode."],
  ),

  /// Cannot go to the previous page because the LOV is already on the first page.
  alreadyOnFirstPage(
    precheckCode: PrecheckCode.alreadyOnFirstPage,
    message: "Cannot go back",
    details: ["You are already on the first page."],
  ),

  /// Cannot go to the next page because the LOV has reached the last page.
  alreadyOnLastPage(
    precheckCode: PrecheckCode.alreadyOnLastPage,
    message: "Cannot go forward",
    details: ["You have reached the last page."],
  ),

  /// An error occurred while executing the query allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot query LOV data",
    details: ["An error occurred during the query permission check."],
  ),

  /// The query operation was cancelled by the user.
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Query cancelled",
    details: ["The operation was cancelled by the user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const LovQueryPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
