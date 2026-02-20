import '__chk_code.dart';
import '__precheck.dart';

enum BlockQuickMultiItemCreationPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Bulk Items creation is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "Bulk Items creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Bulk Items creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "Bulk Items creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allow to create item.",
    details: ["The application logic does not allow to create a new item."],
  ),
  //
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allow to create item.",
    details: ["The isItemCreationAllowed() method error."],
  ),
  //
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Bulk Items Creation Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQuickMultiItemCreationPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
