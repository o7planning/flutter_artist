part of '../../../flutter_artist.dart';

enum BlockItemDeletionPrecheck implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Can not delete the item",
    details: ["The executor is busy."],
  ),
  // Test Cases: [03a].
  notAllow(
    eCode: ECode.notAllow,
    message: "Can not delete the item",
    details: ["The application logic does not allow to delete this item."],
  ),
  // Test Cases: [03a].
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "Can not delete the item",
    details: ["The isAllowDeleteItem() method is error."],
  ),
  // Test Cases: [03a].
  invalidTarget(
    eCode: ECode.invalidTarget,
    message: "Deletion Ignored",
    details: ["Target item is not in the list"],
  ),
  // Test Cases: [03a].
  noTarget(
    eCode: ECode.noTarget,
    message: "Deletion Ignored",
    details: ["No target item to delete"],
  ),
  // Test Cases: [03a].
  cancelled(
    eCode: ECode.cancelled,
    message: "Deletion Cancelled",
    details: ["Cancelled by user"],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockItemDeletionPrecheck({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
