import '__chk_code.dart';
import '__precheck.dart';

enum StageLoadInitDataPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The Stage load init data is disabled.",
    details: ["The executor is busy."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StageLoadInitDataPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
