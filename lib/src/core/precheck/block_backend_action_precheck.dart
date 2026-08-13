import '__chk_code.dart';
import '__precheck.dart';

enum BlockBackendActionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Backend Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "Backend Action is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  //
  blockInStaleState(
    precheckCode: PrecheckCode.inStaleState,
    message: "Backend Action is disabled.",
    details: ["The block is in an 'stale' state."],
  ),
  //
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "Backend Action is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  //
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Backend Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockBackendActionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
