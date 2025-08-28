import '__chk_code.dart';
import '__precheck.dart';

enum BlockSilentItemUpdatePrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Item update is disabled.",
    details: ["The executor is busy."],
  ),

  //
  blockInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Item update is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Item update is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Item update is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  invalidTarget(
    chkCode: ChkCode.invalidTarget,
    message: "Not allow to update the item.",
    details: ["Item not in the List."],
  ),
  //
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
    message: "Silent Update Item Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockSilentItemUpdatePrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
