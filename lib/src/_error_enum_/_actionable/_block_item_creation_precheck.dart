part of '../../../flutter_artist.dart';

@_RenameAnnotation()
enum BlockItemCreationPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "New item creation is disabled.",
    details: ["The executor is busy."],
  ),
  noForm(
    eCode: ECode.noForm,
    message: "New item creation is disabled.",
    details: ["The block has no form."],
  ),
  inPendingState(
    eCode: ECode.inPendingState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  inErrorState(
    eCode: ECode.inErrorState,
    message: "New item creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  inNoneState(
    eCode: ECode.inNoneState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  notAllow(
    eCode: ECode.notAllow,
    message: "Not allow to create item.",
    details: ["The application logic does not allow to create a new item."],
  ),
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "Not allow to create item.",
    details: ["The isAllowCreateItem() method error."],
  ),
  ;

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemCreationPrecheck({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
