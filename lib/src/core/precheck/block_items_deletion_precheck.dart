import '__chk_code.dart';
import '__precheck.dart';

enum BlockItemsDeletionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not delete the item",
    details: ["The executor is busy."],
  ),
  //
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "Can not delete the item",
    details: ["The application logic does not allow to delete this item."],
  ),
  //
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "Can not delete the item",
    details: ["The isItemDeletionAllowed() method is error."],
  ),

  ///
  /// Try to delete items not in the list.
  ///
  invalidTarget(
    precheckCode: PrecheckCode.invalidTarget,
    message: "Deletion Ignored",
    details: ["Target item is not in the list"],
  ),
  //
  noTarget(
    precheckCode: PrecheckCode.noTarget,
    message: "Deletion Ignored",
    details: ["No target item to delete"],
  ),
  //
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

  const BlockItemsDeletionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
