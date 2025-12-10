import '__chk_code.dart';
import '__precheck.dart';

enum BlockSilentItemUpdatePrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Item update is disabled.",
    details: ["The executor is busy."],
  ),

  //
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "Item update is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Item update is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "Item update is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Not allow to update the item.",
    details: ["Item not in the List."],
  ),
  //
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allow to update the item.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  // Test Cases: [90b].
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allow to update the item.",
    details: ["The isAllowUpdateItem() method error."],
  ),
  // TODO: Not Use?
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Not allow to update the item.",
    details: ["The target item is not available."],
  ),
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Silent Update Item Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockSilentItemUpdatePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
