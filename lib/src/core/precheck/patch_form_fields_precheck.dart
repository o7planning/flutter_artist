import '__chk_code.dart';
import '__precheck.dart';

enum PatchFormFieldsPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Patch-form-fields feature is disabled",
    details: [
      "The executor is busy.",
    ],
  ),
  formInNoneMode(
    precheckCode: PrecheckCode.inNoneMode,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'none' mode.",
    ],
  ),
  formInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'error' state.",
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const PatchFormFieldsPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
