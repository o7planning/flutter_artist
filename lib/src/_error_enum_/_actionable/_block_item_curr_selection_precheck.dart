part of '../../../flutter_artist.dart';

enum BlockItemCurrSelectionPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Cannot refresh the current item.",
    details: ["The executor is busy."],
  ),
  noTarget(
    eCode: ECode.noTarget,
    message: "The Refresh Ignored",
    details: ["No target item to refresh"],
  ),
  invalidTarget(
    eCode: ECode.invalidTarget,
    message: "The Refresh Ignored",
    details: ["Item is not in the List"],
  )
  ;

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemCurrSelectionPrecheck({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
