import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum BlockClearancePrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not clear block.",
    details: ["The executor is busy."],
  ),
  hasActiveUI(
    chkCode: ChkCode.hasActiveUI,
    message: "Can not clear block.",
    details: ["The Block currently has active UI components."],
  ),
  ;

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockClearancePrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
