import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum BlockClearCurrentItemPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not clear current item.",
    details: ["The executor is busy."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockClearCurrentItemPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
