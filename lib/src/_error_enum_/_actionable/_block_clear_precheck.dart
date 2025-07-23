part of '../../../flutter_artist.dart';

@_RenameAnnotation()
enum BlockClearPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Can not clear block.",
    details: ["The executor is busy."],
  ),
  hasActiveUI(
    eCode: ECode.hasActiveUI,
    message: "Can not clear block.",
    details: ["The Block currently has active UI components."],
  ),
  ;

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockClearPrecheck({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
