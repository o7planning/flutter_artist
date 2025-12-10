import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum BlockQueryPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The Block querying is disabled.",
    details: ["The executor is busy."],
  ),
  @Deprecated("Xoa di, thay the bang cach khac")
  filterError(
    precheckCode: PrecheckCode.filterError,
    message: "The Block querying is disabled.",
    details: ["The Filter is Error"],
  ),
  queryBlockedTemporarily(
    precheckCode: PrecheckCode.queryLockedTemporarily,
    message: "The Block querying is disabled.",
    details: ["The Query is Locked Temporarily"],
  ),
  noPreviousPage(
    precheckCode: PrecheckCode.noPreviousPage,
    message: "The Block querying is disabled.",
    details: ["No Previous Page"],
  ),
  noNextPage(
    precheckCode: PrecheckCode.noNextPage,
    message: "The Block querying is disabled.",
    details: ["No Next Page"],
  ),
  noCurrentPagination(
    precheckCode: PrecheckCode.noCurrentPagination,
    message: "The Block querying is disabled.",
    details: ["No Current Pagination"],
  ),
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "The Block querying is disabled.",
    details: ["The application logic does not allow query this block."],
  ),
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "The Block querying is disabled.",
    details: ["The isAllowQuery() method error."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const BlockQueryPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
