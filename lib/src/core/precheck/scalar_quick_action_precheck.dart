import '__chk_code.dart';
import '__precheck.dart';

enum ScalarSilentActionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Silent Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  scalarInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "Silent Action is disabled.",
    details: ["The scalar is in a 'pending' state."],
  ),
  //
  scalarInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Silent Action is disabled.",
    details: ["The scalar is in an 'error' state."],
  ),
  // TODO: Remove this?
  scalarInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "Silent Action is disabled.",
    details: ["The scalar is in an 'none' state."],
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

  const ScalarSilentActionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
