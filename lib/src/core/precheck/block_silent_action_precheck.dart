import '__chk_code.dart';
import '__precheck.dart';

enum BlockSilentActionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Silent Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "Silent Action is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Silent Action is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  //
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "Silent Action is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Silent Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockSilentActionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
