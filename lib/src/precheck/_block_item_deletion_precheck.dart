import '__chk_code.dart';
import '__chk_code_detail.dart';

enum BlockItemDeletionPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not delete the item",
    details: ["The executor is busy."],
  ),
  // Test Cases: [03a].
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Can not delete the item",
    details: ["The application logic does not allow to delete this item."],
  ),
  // Test Cases: [03a].
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Can not delete the item",
    details: ["The isAllowDeleteItem() method is error."],
  ),
  // Test Cases: [03a].
  ///
  /// Try to delete item not in the list.
  ///
  invalidTarget(
    chkCode: ChkCode.invalidTarget,
    message: "Deletion Ignored",
    details: ["Target item is not in the list"],
  ),
  // Test Cases: [03a].
  noTarget(
    chkCode: ChkCode.noTarget,
    message: "Deletion Ignored",
    details: ["No target item to delete"],
  ),
  // Test Cases: [03a].
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Deletion Cancelled",
    details: ["Cancelled by user"],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemDeletionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
