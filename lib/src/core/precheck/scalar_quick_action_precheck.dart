import '__chk_code.dart';
import '__chk_code_detail.dart';

enum ScalarQuickActionPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Quick Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  scalarInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Quick Action is disabled.",
    details: ["The scalar is in a 'pending' state."],
  ),
  //
  scalarInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Quick Action is disabled.",
    details: ["The scalar is in an 'error' state."],
  ),
  // TODO: Remove this?
  scalarInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Quick Action is disabled.",
    details: ["The scalar is in an 'none' state."],
  ),
  //
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Quick Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ScalarQuickActionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
