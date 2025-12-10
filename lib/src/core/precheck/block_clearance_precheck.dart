import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum BlockClearancePrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not clear block.",
    details: ["The executor is busy."],
  ),
  hasActiveUI(
    precheckCode: PrecheckCode.hasActiveUI,
    message: "Can not clear block.",
    details: ["The Block currently has active UI components."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockClearancePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
