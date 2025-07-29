part of '../../_fa_core.dart';

enum BlockQuickUpdateItemPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Item update is disabled.",
    details: ["The executor is busy."],
  ),

  // Test Cases: [91b].
  blockInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Item update is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  // Test Cases: [91b].
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Item update is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  // Test Cases: [91b].
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Item update is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  // Test Cases: [90b], [91b].
  invalidTarget(
    chkCode: ChkCode.invalidTarget,
    message: "Not allow to update the item.",
    details: ["Item not in the List."],
  ),
  // Test Cases: [90b].
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Not allow to update the item.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  // Test Cases: [90b].
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Not allow to update the item.",
    details: ["The isAllowUpdateItem() method error."],
  ),
  // TODO: Not Use?
  noTarget(
    chkCode: ChkCode.noTarget,
    message: "Not allow to update the item.",
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
