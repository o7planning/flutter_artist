import '__chk_code.dart';
import '__precheck.dart';

enum FormModelViewChangedPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not execute.",
    details: ["The executor is busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FormModelViewChangedPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
