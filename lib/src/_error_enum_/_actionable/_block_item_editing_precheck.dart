part of '../../../flutter_artist.dart';

enum BlockItemEditiingPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Item edit is disabled.",
    details: ["The executor is busy."],
  ),
  noForm(
    eCode: ECode.noForm,
    message: "The item cannot be edited on the form.",
    details: ["The block has no form."],
  ),
  formInErrorState(
    eCode: ECode.inErrorState,
    message: "The item cannot be edited on the form.",
    details: ["Form data state is error."],
  ),

  // Block In Pending State.
  inPendingState(
    eCode: ECode.inPendingState,
    message: "Item edit is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  blockInErrorState(
    eCode: ECode.inErrorState,
    message: "Item edit is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  blockInNoneState(
    eCode: ECode.inNoneState,
    message: "Item update is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  formModeInNone(
    eCode: ECode.inNoneMode,
    message: "The item cannot be edited on the form.",
    details: ["The form is in 'none' mode."],
  ),
  notAllow(
    eCode: ECode.notAllow,
    message: "Not allow to edit the item.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "Not allow to edit the item.",
    details: ["The isAllowUpdateItem() method error."],
  ),
  noTarget(
    eCode: ECode.noTarget,
    message: "Not allow to edit item.",
    details: ["The target item is not available."],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemEditiingPrecheck({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
