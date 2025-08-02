import '__chk_code.dart';
import '__precheck.dart';

enum BlockMultiItemsCreationPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Multi Items creation is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Multi Items creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Multi Items creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Multi Items creation is disabled.",
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
  ),
  //
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Quick Create Item Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockMultiItemsCreationPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
