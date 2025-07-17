part of '../../../flutter_artist.dart';

enum BlockAllowEditItemCode implements ECodeDetail {
  notAllow(
    eCode: ECode.notAllow,
    message: "Not allow to edit the item.",
    details: ["The application logic does not allow to edit this item."],
  ),
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "Not allow to edit the item.",
    details: ["The isAllowUpdateItem() method error."],
  );

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockAllowEditItemCode({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
