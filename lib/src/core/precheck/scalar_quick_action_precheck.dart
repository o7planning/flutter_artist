import '__chk_code.dart';
import '__precheck.dart';

enum StorageBackendActionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Backend Action is disabled.",
    details: ["The executor is busy."],
  ),
  //
  cancelled(
    precheckCode: PrecheckCode.cancelled,
    message: "Backend Action Cancelled.",
    details: null,
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const StorageBackendActionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
