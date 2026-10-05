part of '../__precheck.dart';

/// Precheck enumeration for block query operations.
enum BlockQueryPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot query data",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Cannot query data",
    details: [
      "Application business rules do not allow querying this block at the moment."
    ],
  ),

  /// Pagination operations (next/previous/more page) are not supported
  /// because the block is configured in full-query mode.
  pageableNotSupported(
    precheckCode: PrecheckCode.pageableNotSupported,
    message: "Cannot paginate",
    details: ["Pagination is not supported under the current full-query mode."],
  ),

  /// Cannot go to the previous page because the block is already on the first page.
  alreadyOnFirstPage(
    precheckCode: PrecheckCode.alreadyOnFirstPage,
    // Hoặc mã precheck phù hợp trong hệ thống
    message: "Cannot go back",
    details: ["You are already on the first page."],
  ),

  /// Cannot go to the next page because the block has reached the last page.
  alreadyOnLastPage(
    precheckCode: PrecheckCode.alreadyOnLastPage,
    message: "Cannot go forward",
    details: ["You have reached the last page."],
  ),

  /// An error occurred while executing the query allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Cannot query data",
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

  const BlockQueryPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
