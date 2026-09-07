import '__chk_code.dart';
import '__precheck.dart';

enum FormModelPatchFormFieldsPrecheck implements Precheck {
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
  formInPendingState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'pending' state.",
    ],
  ),
  formInFatalErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'fatal error' state.",
    ],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FormModelPatchFormFieldsPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
