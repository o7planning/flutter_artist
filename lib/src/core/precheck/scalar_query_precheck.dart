import '__chk_code.dart';
import '__precheck.dart';

// Name (OK)
enum ScalarQueryPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The Scalar querying is disabled.",
    details: ["The executor is busy."],
  ),
  @Deprecated("Xoa di, thay the bang cach khac")
  filterError(
    precheckCode: PrecheckCode.filterError,
    message: "The Scalar querying is disabled.",
    details: ["The Filter is Error"],
  ),
  notAllow(
    precheckCode: PrecheckCode.notAllow,
    message: "The Scalar querying is disabled.",
    details: ["The application logic does not allow query this block."],
  ),
  checkAllowMethodError(
    precheckCode: PrecheckCode.checkAllowMethodError,
    message: "The Scalar querying is disabled.",
    details: ["The isQueryAllowed() method error."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ScalarQueryPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
