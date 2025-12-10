import '__chk_code.dart';
import '__precheck.dart';

enum StorageSilentActionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Silent Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Silent Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StorageSilentActionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
