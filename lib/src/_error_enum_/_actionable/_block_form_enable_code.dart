part of '../../../flutter_artist.dart';

enum BlockFormEnableCode implements ECodeDetail {
  noForm(
    eCode: ECode.noForm,
    message: "Block has no Form",
    details: [],
  ),
  formInNoneMode(
    eCode: ECode.inNoneMode,
    message: "The Form is disabled",
    details: ["The form in 'none' mode"],
  ),
  formInitialDataNotReady(
    eCode: ECode.formInitialDataNotReady,
    message: "The Form is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  notAllow(
    eCode: ECode.notAllow,
    message: "The Form is disabled.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "The Form is disabled.",
    details: ["The isAllowUpdateItem() method error."],
  ),
  ;

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormEnableCode({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
