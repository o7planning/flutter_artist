import '__chk_code.dart';
import '__precheck.dart';

enum BlockFormPatchFormFieldPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form patch is disabled.",
    details: ["The system is busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormPatchFormFieldPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
