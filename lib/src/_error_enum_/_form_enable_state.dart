part of '../../flutter_artist.dart';

enum FormEnableState implements ECodeDetail {
  noForm(
    eCode: ECode.noForm,
    message: "Block has no Form",
    details: [],
  ),

  formInNoneMode(
    eCode: ECode.inNoneMode,
    message: "The Form is disabled",
    details: ["The form in 'none' mode"],
  ),

  formInitialDataNotReady(
    eCode: ECode.formInitialDataNotReady,
    message: "The Form is disabled.",
    details: ["The formInitialData is not ready."],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FormEnableState({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
