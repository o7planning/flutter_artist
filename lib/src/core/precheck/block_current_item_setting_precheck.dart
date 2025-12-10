import '__chk_code.dart';
import '__precheck.dart';

enum BlockCurrentItemSettingPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Cannot refresh the current item.",
    details: ["The executor is busy."],
  ),
  // Test Cases: [03b]
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "The Refresh Ignored",
    details: ["No target item to refresh"],
  ),
  // Test Cases: [03b]
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "The Refresh Ignored",
    details: ["Item is not in the List"],
  ),
  // Test Cases: [03b] ??
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "The Refresh Ignored",
    details: ["Not Allow to Refresh Item"],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockCurrentItemSettingPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
