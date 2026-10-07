part of '../__precheck.dart';

/// Precheck enumeration for block form enable operations.
enum BlockFormEnablePrecheck implements FormEnablePrecheck {
  /// Operation aborted because the block state is not ready for the form.
  hostStateNotReadyForForm(
    precheckCode: PrecheckCode.noForm,
    message: "Block state is not ready for form.",
    details: ["The underlying block state does not permit form interaction."],
  ),

  /// Operation aborted because no form model is configured.
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Block has no form.",
    details: ["No form model is configured for this block."],
  ),

  /// Operation aborted because the form is in a none state.
  formInNoneState(
    precheckCode: PrecheckCode.formInNoneState,
    message: "Block form is disabled.",
    details: ["The form is currently in a 'none' state."],
  ),

  /// Operation aborted because the form is in a pending state.
  formInPendingState(
    precheckCode: PrecheckCode.formInPendingState,
    message: "Block form is disabled.",
    details: ["The form is currently in a 'pending' state."],
  ),

  /// Operation aborted because the form is in a fatal error state.
  formInFatalErrorState(
    precheckCode: PrecheckCode.formInFatalErrorState,
    message: "Block form is disabled.",
    details: ["The form is currently in a fatal error state."],
  ),

  /// Operation aborted because the form is in a stale state.
  formInStaleState(
    precheckCode: PrecheckCode.formInStaleState,
    message: "Block form is disabled.",
    details: ["The form is currently in a stale state."],
  ),

  /// Operation not allowed by application business rules.
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "The form is disabled.",
    details: ["Application business rules do not allow updating this item."],
  ),

  /// An error occurred while executing the item update allow-check method.
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "The form is disabled.",
    details: ["An error occurred during the item update permission check."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockFormEnablePrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
