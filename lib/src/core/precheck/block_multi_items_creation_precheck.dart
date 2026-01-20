import '__chk_code.dart';
import '__precheck.dart';

enum BlockMultiItemsCreationPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Multi Items creation is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "Multi Items creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Multi Items creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "Multi Items creation is disabled.",
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
    message: "Quick Create Item Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockMultiItemsCreationPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
