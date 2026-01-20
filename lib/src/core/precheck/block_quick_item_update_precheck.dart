import '__chk_code.dart';
import '__precheck.dart';

enum BlockQuickItemUpdatePrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Item update is disabled.",
    details: ["The executor is busy."],
  ),

  // Test Cases: [91b].
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "Item update is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  // Test Cases: [91b].
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Item update is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  // Test Cases: [91b].
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "Item update is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  // Test Cases: [90b], [91b].
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Not allow to update the item.",
    details: ["Item not in the List."],
  ),
  // Test Cases: [90b].
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allow to update the item.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  // Test Cases: [90b].
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allow to update the item.",
    details: ["The isItemUpdateAllowed() method error."],
  ),
  // TODO: Not Use?
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Not allow to update the item.",
    details: ["The target item is not available."],
  ),
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Quick Update Item Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickItemUpdatePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
