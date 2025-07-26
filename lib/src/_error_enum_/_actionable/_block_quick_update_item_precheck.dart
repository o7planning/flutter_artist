part of '../../../flutter_artist.dart';

enum BlockQuickUpdateItemPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Item edit is disabled.",
    details: ["The executor is busy."],
  ),
  noForm(
    chkCode: ChkCode.noForm,
    message: "The item cannot be edited on the form.",
    details: ["The block has no form."],
  ),
  formInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "The item cannot be edited on the form.",
    details: ["Form data state is error."],
  ),

  // Block In Pending State.
  inPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Item edit is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Item edit is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Item update is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  formModeInNone(
    chkCode: ChkCode.inNoneMode,
    message: "The item cannot be edited on the form.",
    details: ["The form is in 'none' mode."],
  ),
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Not allow to edit the item.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Not allow to edit the item.",
    details: ["The isAllowUpdateItem() method error."],
  ),
  noTarget(
    chkCode: ChkCode.noTarget,
    message: "Not allow to edit item.",
    details: ["The target item is not available."],
  ),
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Quick Update Item Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickUpdateItemPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
