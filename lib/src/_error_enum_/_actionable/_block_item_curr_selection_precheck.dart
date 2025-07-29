part of '../../_fa_core.dart';

enum BlockItemCurrSelectionPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Cannot refresh the current item.",
    details: ["The executor is busy."],
  ),
  // Test Cases: [03b]
  noTarget(
    chkCode: ChkCode.noTarget,
    message: "The Refresh Ignored",
    details: ["No target item to refresh"],
  ),
  // Test Cases: [03b]
  invalidTarget(
    chkCode: ChkCode.invalidTarget,
    message: "The Refresh Ignored",
    details: ["Item is not in the List"],
  ),
  // Test Cases: [03b] ??
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "The Refresh Ignored",
    details: ["Not Allow to Refresh Item"],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemCurrSelectionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
