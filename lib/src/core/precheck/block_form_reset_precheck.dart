import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum BlockFormResetPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form reset is disabled.",
    details: ["The executor is busy."],
  ),
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Form reset is disabled.",
    details: ["The block has no form."],
  ),
  formIsNotDirty(
    precheckCode: PrecheckCode.formIsNotDirty,
    message: "Form reset is disabled.",
    details: ["The form is not in dirty state."],
  ),
  formInitialDataNotReady(
    precheckCode: PrecheckCode.formInitialDataNotReady,
    message: "Form reset is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  formInNoneMode(
    precheckCode: PrecheckCode.inNoneMode,
    message: "Form reset is disabled.",
    details: ["The form is in 'none' mode."],
  ),
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Form Resetting is disabled.",
    details: ["The application logic does not allow to reset the form."],
  ),
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Form Resetting is disabled.",
    details: ["The isFormResetAllowed() method error.."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormResetPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
