import '__chk_code.dart';
import '__precheck.dart';

enum BackgroundActionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Background Action is disabled.",
    details: ["The executor is busy."],
  ),
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Background Action cancelled.",
    details: null,
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BackgroundActionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
