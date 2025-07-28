part of '../../../flutter_artist.dart';

enum BlockQuickActionPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "New item creation is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "New item creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Quick Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickActionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
