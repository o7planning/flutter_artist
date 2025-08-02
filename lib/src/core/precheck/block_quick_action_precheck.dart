import '__chk_code.dart';
import '__precheck.dart';

enum BlockQuickActionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Quick Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Quick Action is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Quick Action is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Quick Action is disabled.",
    details: ["The block is in a 'none' state."],
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

  const BlockQuickActionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
