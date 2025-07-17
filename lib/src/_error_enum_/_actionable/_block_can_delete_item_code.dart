part of '../../../flutter_artist.dart';

enum BlockCanDeleteItemCode implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Can not delete the item",
    details: ["The executor is busy."],
  ),
  notAllow(
    eCode: ECode.notAllow,
    message: "Can not delete the item",
    details: ["The application logic does not allow to delete this item."],
  ),
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "Can not delete the item",
    details: ["The isAllowDeleteItem() method is error."],
  ),
  noTarget(
    eCode: ECode.noTarget,
    message: "Deletion Ignored",
    details: ["No target item to delete"],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockCanDeleteItemCode({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
