import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum ScalarClearancePrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not clear scalar.",
    details: ["The executor is busy."],
  ),
  hasActiveUI(
    chkCode: ChkCode.hasActiveUI,
    message: "Can not clear scalar.",
    details: ["The Scalar currently has active UI components."],
  ),
  ;

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ScalarClearancePrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
