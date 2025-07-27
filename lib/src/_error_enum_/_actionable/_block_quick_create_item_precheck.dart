part of '../../../flutter_artist.dart';

enum BlockQuickCreateItemPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "New item creation is disabled.",
    details: ["The executor is busy."],
  ),
  // Test Cases: [91a].
  inPendingState(
    chkCode: ChkCode.inPendingState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  // Test Cases: [91a].
  inErrorState(
    chkCode: ChkCode.inErrorState,
    message: "New item creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  // Test Cases: [91a].
  inNoneState(
    chkCode: ChkCode.inNoneState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  // Test Cases: [90b].
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Not allow to create item.",
    details: ["The application logic does not allow to create a new item."],
  ),
  // Test Cases: [90b].
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Not allow to create item.",
    details: ["The isAllowCreateItem() method error."],
  ),
  // Test Cases: [90b].
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Quick Create Item Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickCreateItemPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
