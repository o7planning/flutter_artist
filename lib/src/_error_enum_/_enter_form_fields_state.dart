part of '../../flutter_artist.dart';

enum EnterFormFieldsState implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The executor is busy.",
    ],
  ),
  formInNoneMode(
    eCode: ECode.inNoneMode,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'none' mode.",
    ],
  ),
  formInErrorState(
    eCode: ECode.inErrorState,
    message: "Enter-form-fields feature is disabled",
    details: [
      "The form in 'error' state.",
    ],
  )
  ;

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const EnterFormFieldsState({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
