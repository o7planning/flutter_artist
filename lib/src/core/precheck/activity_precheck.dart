import '__chk_code.dart';
import '__precheck.dart';

enum ActivityPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not clear scalar.",
    details: ["The executor is busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ActivityPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
