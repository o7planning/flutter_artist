part of '../../../flutter_artist.dart';

enum BlockItemSaveState implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Form saving is disabled.",
    details: ["The block has no form."],
  ),
  noForm(
    eCode: ECode.noForm,
    message: "Form saving is disabled.",
    details: ["The block has no form."],
  ),
  formInitialDataNotReady(
    eCode: ECode.formInitialDataNotReady,
    message: "Form saving is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  formIsNotDirty(
    eCode: ECode.formIsNotDirty,
    message: "Form saving is disabled.",
    details: ["The form is not dirty."],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemSaveState({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
