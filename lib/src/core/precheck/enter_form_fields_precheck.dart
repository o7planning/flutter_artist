import '__chk_code.dart';
import '__chk_code_detail.dart';

enum EnterFormFieldsPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The executor is busy.",
    ],
  ),
  formInNoneMode(
    chkCode: ChkCode.inNoneMode,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'none' mode.",
    ],
  ),
  formInErrorState(
    chkCode: ChkCode.inErrorState,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'error' state.",
    ],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const EnterFormFieldsPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
