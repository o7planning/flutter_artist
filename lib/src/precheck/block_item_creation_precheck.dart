
import '../core/annotation/annotation.dart';
import '__chk_code.dart';
import '__chk_code_detail.dart';

@RenameAnnotation()
enum BlockItemCreationPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "New item creation is disabled.",
    details: ["The executor is busy."],
  ),
  // Test Cases: [01a]
  noForm(
    chkCode: ChkCode.noForm,
    message: "New item creation is disabled.",
    details: ["The block has no form."],
  ),
  // Test Cases: [01b]
  blockInPendingState(
    chkCode: ChkCode.inPendingState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'pending' state."],
  ),
  // Test Cases: [01b]
  blockInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "New item creation is disabled.",
    details: ["The block is in an 'error' state."],
  ),
  // Test Cases: [01a]
  blockInNoneState(
    chkCode: ChkCode.inNoneState,
    message: "New item creation is disabled.",
    details: ["The block is in a 'none' state."],
  ),
  // Test Cases: [01a]
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Not allow to create item.",
    details: ["The application logic does not allow to create a new item."],
  ),
  // Test Cases: [01a]
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Not allow to create item.",
    details: ["The isAllowCreateItem() method error."],
  ),
  ;

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemCreationPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
