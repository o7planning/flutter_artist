import '__chk_code.dart';
import '__precheck.dart';

enum BlockItemEditPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Item edit is disabled.",
    details: ["The executor is busy."],
  ),
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "The item cannot be edited on the form.",
    details: ["The block has no form."],
  ),
  formInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "The item cannot be edited on the form.",
    details: ["Form data state is error."],
  ),

  // Block In Pending State.
  inPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "Item edit is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "Item edit is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "Item update is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  formModeInNone(
    precheckCode: PrecheckCode.inNoneMode,
    message: "The item cannot be edited on the form.",
    details: ["The form is in 'none' mode."],
  ),
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allow to edit the item.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allow to edit the item.",
    details: ["The isItemUpdateAllowed() method error."],
  ),
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Not allow to edit item.",
    details: ["The target item is not available."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemEditPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
