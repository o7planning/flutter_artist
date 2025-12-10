import '__chk_code.dart';
import '__precheck.dart';

enum FormModelDataLoadPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not load form data.",
    details: ["The executor is busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FormModelDataLoadPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
