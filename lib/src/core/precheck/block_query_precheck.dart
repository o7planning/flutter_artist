import '__chk_code.dart';
import '__chk_code_detail.dart';

// Name (OK)
enum BlockQueryPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "The Block querying is disabled.",
    details: ["The executor is busy."],
  ),
  @Deprecated("Xoa di, thay the bang cach khac")
  filterError(
    chkCode: ChkCode.filterError,
    message: "The Block querying is disabled.",
    details: ["The Filter is Error"],
  ),
  queryBlockedTemporarily(
    chkCode: ChkCode.queryLockedTemporarily,
    message: "The Block querying is disabled.",
    details: ["The Query is Locked Temporarily"],
  ),
  noPreviousPage(
    chkCode: ChkCode.noPreviousPage,
    message: "The Block querying is disabled.",
    details: ["No Previous Page"],
  ),
  noNextPage(
    chkCode: ChkCode.noNextPage,
    message: "The Block querying is disabled.",
    details: ["No Next Page"],
  ),
  noCurrentPagination(
    chkCode: ChkCode.noCurrentPagination,
    message: "The Block querying is disabled.",
    details: ["No Current Pagination"],
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
