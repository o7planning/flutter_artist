part of '../../../flutter_artist.dart';

@_RenameAnnotation()
enum BlockFormResetingPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Form reset is disabled.",
    details: ["The executor is busy."],
  ),
  noForm(
    chkCode: ChkCode.noForm,
    message: "Form reset is disabled.",
    details: ["The block has no form."],
  ),
  formIsNotDirty(
    chkCode: ChkCode.formIsNotDirty,
    message: "Form reset is disabled.",
    details: ["The form is not in dirty state."],
  ),
  formInitialDataNotReady(
    chkCode: ChkCode.formInitialDataNotReady,
    message: "Form reset is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  formInNoneMode(
    chkCode: ChkCode.inNoneMode,
    message: "Form reset is disabled.",
    details: ["The form is in 'none' mode."],
  ),
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Form Resetting is disabled.",
    details: ["The application logic does not allow to reset the form."],
  ),
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Form Resetting is disabled.",
    details: ["The isAllowResetForm() method error.."],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormResetingPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
