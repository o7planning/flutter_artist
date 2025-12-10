import '__chk_code.dart';
import '__precheck.dart';

enum ShelfQueuedEventExecutionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not execute queued event",
    details: ["The executor is busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShelfQueuedEventExecutionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
