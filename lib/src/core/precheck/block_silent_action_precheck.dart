import '__chk_code.dart';
import '__precheck.dart';

enum BlockSilentActionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Silent Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Silent Action is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Silent Action is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Silent Action is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Silent Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockSilentActionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
