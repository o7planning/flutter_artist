part of '../../../flutter_artist.dart';

enum BlockItemCurrSelectionPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Cannot refresh the current item.",
    details: ["The executor is busy."],
  ),
  // Test Cases: [03b]
  noTarget(
    eCode: ECode.noTarget,
    message: "The Refresh Ignored",
    details: ["No target item to refresh"],
  ),
  // Test Cases: [03b]
  invalidTarget(
    eCode: ECode.invalidTarget,
    message: "The Refresh Ignored",
    details: ["Item is not in the List"],
  ),
  // Test Cases: [03b] ??
  notAllow(
    eCode: ECode.notAllow,
    message: "The Refresh Ignored",
    details: ["Not Allow to Refresh Item"],
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
