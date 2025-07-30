import '__chk_code.dart';
import '__chk_code_detail.dart';

// Name (OK)
enum ScalarQueryPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "The Scalar querying is disabled.",
    details: ["The executor is busy."],
  ),
  @Deprecated("Xoa di, thay the bang cach khac")
  filterError(
    chkCode: ChkCode.filterError,
    message: "The Scalar querying is disabled.",
    details: ["The Filter is Error"],
  ),
  notAllow(
    chkCode: ChkCode.notAllow,
    message: "The Scalar querying is disabled.",
    details: ["The application logic does not allow query this block."],
  ),
  checkAllowMethodError(
    chkCode: ChkCode.checkAllowMethodError,
    message: "The Scalar querying is disabled.",
    details: ["The isAllowQuery() method error."],
  ),
  ;

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ScalarQueryPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
