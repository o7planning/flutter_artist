part of '../../../flutter_artist.dart';

@_RenameAnnotation()
enum BlockFormResetingPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Form reset is disabled.",
    details: ["The executor is busy."],
  ),
  noForm(
    eCode: ECode.noForm,
    message: "Form reset is disabled.",
    details: ["The block has no form."],
  ),
  formIsNotDirty(
    eCode: ECode.formIsNotDirty,
    message: "Form reset is disabled.",
    details: ["The form is not in dirty state."],
  ),
  formInitialDataNotReady(
    eCode: ECode.formInitialDataNotReady,
    message: "Form reset is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  formInNoneMode(
    eCode: ECode.inNoneMode,
    message: "Form reset is disabled.",
    details: ["The form is in 'none' mode."],
  ),
  notAllow(
    eCode: ECode.notAllow,
    message: "Form Resetting is disabled.",
    details: ["The application logic does not allow to reset the form."],
  ),
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "Form Resetting is disabled.",
    details: ["The isAllowResetForm() method error.."],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormResetingPrecheck({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
