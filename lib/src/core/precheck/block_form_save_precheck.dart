import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum BlockFormSavePrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Form saving is disabled.",
    details: ["The block has no form."],
  ),
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Form saving is disabled.",
    details: ["The block has no form."],
  ),
  formInitialDataNotReady(
    precheckCode: PrecheckCode.formInitialDataNotReady,
    message: "Form saving is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  formIsNotDirty(
    precheckCode: PrecheckCode.formIsNotDirty,
    message: "Form saving is disabled.",
    details: ["The form is not dirty."],
  ),
  formInvalidated(
    precheckCode: PrecheckCode.formInvalidated,
    message: "Form saving is disabled.",
    details: ["The form is invalidated."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormSavePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
