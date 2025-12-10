import '../annotation/annotation.dart';
import '__chk_code.dart';
import '__precheck.dart';

@RenameAnnotation()
enum BlockItemCreationPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "New item creation is disabled.",
    details: ["The executor is busy."],
  ),
  // Test Cases: [01a]
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "New item creation is disabled.",
    details: ["The block has no form."],
  ),
  // Test Cases: [01b]
  blockInPendingState(
    precheckCode: PrecheckCode.inPendingState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  // Test Cases: [01b]
  blockInErrorState(
    precheckCode: PrecheckCode.inErrorState,
    message: "New item creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  // Test Cases: [01a]
  blockInNoneState(
    precheckCode: PrecheckCode.inNoneState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  // Test Cases: [01a]
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Not allow to create item.",
    details: ["The application logic does not allow to create a new item."],
  ),
  // Test Cases: [01a]
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Not allow to create item.",
    details: ["The isAllowCreateItem() method error."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemCreationPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
