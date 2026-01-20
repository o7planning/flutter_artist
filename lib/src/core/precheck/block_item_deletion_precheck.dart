import '__chk_code.dart';
import '__precheck.dart';

enum BlockItemDeletionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not delete the item",
    details: ["The executor is busy."],
  ),
  // Test Cases: [03a].
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Can not delete the item",
    details: ["The application logic does not allow to delete this item."],
  ),
  // Test Cases: [03a].
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Can not delete the item",
    details: ["The isItemDeletionAllowed() method is error."],
  ),
  // Test Cases: [03a].
  ///
  /// Try to delete item not in the list.
  ///
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Deletion Ignored",
    details: ["Target item is not in the list"],
  ),
  // Test Cases: [03a].
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Deletion Ignored",
    details: ["No target item to delete"],
  ),
  // Test Cases: [03a].
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Deletion Cancelled",
    details: ["Cancelled by user"],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemDeletionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
