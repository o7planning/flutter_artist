part of '../../flutter_artist.dart';

enum BlockQueryState implements ECodeDetail {
  busy(
    eCode: ECode.busy,
    message: "Block Querying is disabled.",
    details: ["The executor is busy."],
  ),

  notAllowToQuery(
    eCode: ECode.notAllow,
    message: "The Block querying is disabled.",
    details: ["The application logic does not allow query this block."],
  ),

  isAllowQueryMethodError(
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

  const BlockQueryState({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
