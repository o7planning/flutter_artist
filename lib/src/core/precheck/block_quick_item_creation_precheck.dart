import '__chk_code.dart';
import '__precheck.dart';

enum BlockQuickItemCreationPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "New item creation is disabled.",
    details: ["The executor is busy."],
  ),
  // Test Cases: [91a].
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  // Test Cases: [91a].
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "New item creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  // Test Cases: [91a].
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  // Test Cases: [90b].
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allow to create item.",
    details: ["The application logic does not allow to create a new item."],
  ),
  // Test Cases: [90b].
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allow to create item.",
    details: ["The isItemCreationAllowed() method error."],
  ),
  // Test Cases: [90b].
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Quick Create Item Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickItemCreationPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
