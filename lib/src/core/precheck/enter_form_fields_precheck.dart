import '__chk_code.dart';
import '__precheck.dart';

enum EnterFormFieldsPrecheck implements Precheck {
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
