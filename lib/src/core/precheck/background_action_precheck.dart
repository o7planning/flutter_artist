import '__chk_code.dart';
import '__precheck.dart';

enum BackgroundActionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Background Action is disabled.",
    details: ["The executor is busy."],
  ),
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Background Action cancelled.",
    details: null,
  ),
  ;

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BackgroundActionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
