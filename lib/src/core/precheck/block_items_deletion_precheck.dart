import '__chk_code.dart';
import '__precheck.dart';

enum BlockItemsDeletionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not delete the item",
    details: ["The executor is busy."],
  ),
  //
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "Can not delete the item",
    details: ["The application logic does not allow to delete this item."],
  ),
  //
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "Can not delete the item",
    details: ["The isAllowDeleteItem() method is error."],
  ),
  //
  ///
  /// Try to delete items not in the list.
  ///
  invalidTarget(
    chkCode: ChkCode.invalidTarget,
    message: "Deletion Ignored",
    details: ["Target item is not in the list"],
  ),
  //
  noTarget(
    chkCode: ChkCode.noTarget,
    message: "Deletion Ignored",
    details: ["No target item to delete"],
  ),
  //
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

  const BlockItemsDeletionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
