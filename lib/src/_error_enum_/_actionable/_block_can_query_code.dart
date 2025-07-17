part of '../../../flutter_artist.dart';

enum BlockCanQueryCode implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Block Querying is disabled.",
    details: ["The executor is busy."],
  ),
  notAllow(
    eCode: ECode.notAllow,
    message: "The Block querying is disabled.",
    details: ["The application logic does not allow query this block."],
  ),
  checkAllowMethodError(
    eCode: ECode.checkAllowMethodError,
    message: "The Block querying is disabled.",
    details: ["The isAllowQuery() method error."],
  ),
  ;

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockCanQueryCode({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
