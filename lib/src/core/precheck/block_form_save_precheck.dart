import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum BlockFormSavePrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Form saving is disabled.",
    details: ["The block has no form."],
  ),
  noForm(
    chkCode: ChkCode.noForm,
    message: "Form saving is disabled.",
    details: ["The block has no form."],
  ),
  formInitialDataNotReady(
    chkCode: ChkCode.formInitialDataNotReady,
    message: "Form saving is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  formIsNotDirty(
    chkCode: ChkCode.formIsNotDirty,
    message: "Form saving is disabled.",
    details: ["The form is not dirty."],
  ),
  formInvalidated(
    chkCode: ChkCode.formInvalidated,
    message: "Form saving is disabled.",
    details: ["The form is invalidated."],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormSavePrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
