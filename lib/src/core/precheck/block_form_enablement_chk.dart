import '../annotation/annotation.dart';
import '__chk_code.dart';
import '__precheck.dart';

@RenameAnnotation()
enum BlockFormEnablementPrecheckCode implements Precheck {
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Block has no Form",
    details: [],
  ),
  formInNoneMode(
    precheckCode: PrecheckCode.inNoneMode,
    message: "The Form is disabled",
    details: ["The form in 'none' mode"],
  ),
  formInitialDataNotReady(
    precheckCode: PrecheckCode.formInitialDataNotReady,
    message: "The Form is disabled.",
    details: ["The formInitialData is not ready."],
  ),
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "The Form is disabled.",
    details: ["The application logic does not allow this item to be updated."],
  ),
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "The Form is disabled.",
    details: ["The isItemUpdateAllowed() method error."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormEnablementPrecheckCode({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
