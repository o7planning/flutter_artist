part of '../../../flutter_artist.dart';

enum BlockQuickCreateItemPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "New item creation is disabled.",
    details: ["The executor is busy."],
  ),
  //
  noForm(
    chkCode: ChkCode.noForm,
    message: "New item creation is disabled.",
    details: ["The block has no form."],
  ),
  //
  inPendingState(
    chkCode: ChkCode.inPendingState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  inErrorState(
    chkCode: ChkCode.inErrorState,
    message: "New item creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  inNoneState(
    chkCode: ChkCode.inNoneState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Not allow to create item.",
    details: ["The application logic does not allow to create a new item."],
  ),
  //
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Not allow to create item.",
    details: ["The isAllowCreateItem() method error."],
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
