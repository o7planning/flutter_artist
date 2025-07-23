part of '../../../flutter_artist.dart';

enum BlockQueryPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Block Querying is disabled.",
    details: ["The executor is busy."],
  ),
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "The Block querying is disabled.",
    details: ["The application logic does not allow query this block."],
  ),
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "The Block querying is disabled.",
    details: ["The isAllowQuery() method error."],
  ),
  ;

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQueryPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
