import '__chk_code.dart';
import '__precheck.dart';

enum StorageSilentActionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Silent Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  cancelled(
    chkCode: ChkCode.cancelled,
    message: "Silent Action Cancelled.",
    details: null,
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StorageSilentActionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
