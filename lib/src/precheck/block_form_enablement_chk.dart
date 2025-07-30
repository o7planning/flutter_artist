
import '../core/annotation/annotation.dart';
import '__chk_code.dart';
import '__chk_code_detail.dart';

@RenameAnnotation()
enum BlockFormEnablementChkCode implements ChkCodeDetail {
  noForm(
    chkCode: ChkCode.noForm,
    message: "Block has no Form",
    details: [],
  ),
  formInNoneMode(
    chkCode: ChkCode.inNoneMode,
    message: "The Form is disabled",
    details: ["The form in 'none' mode"],
  ),
  formInitialDataNotReady(
    chkCode: ChkCode.formInitialDataNotReady,
    message: "The Form is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "The Form is disabled.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "The Form is disabled.",
    details: ["The isAllowUpdateItem() method error."],
  ),
  ;

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormEnablementChkCode({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
