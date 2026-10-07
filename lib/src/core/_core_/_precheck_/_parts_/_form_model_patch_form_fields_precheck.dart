part of '../__precheck.dart';

/// Precheck enumeration for form model patch form fields operations.
enum FormModelPatchFormFieldsPrecheck implements Precheck {
  /// Operation aborted because the system executor is currently busy.
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Patching form fields is disabled.",
    details: ["The system executor is currently busy. Please wait."],
  ),

  /// Operation aborted because the form is in a none state.
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Patching form fields is disabled.",
    details: ["The form is currently in a 'none' state."],
  ),

  /// Operation aborted because the form is in a pending state.
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Patching form fields is disabled.",
    details: ["The form is currently in a 'pending' state."],
  ),

  /// Operation aborted because the form is in a fatal error state.
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Patching form fields is disabled.",
    details: ["The form is currently in a fatal error state."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FormModelPatchFormFieldsPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
