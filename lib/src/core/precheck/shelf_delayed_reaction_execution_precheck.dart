import '__chk_code.dart';
import '__precheck.dart';

enum ShelfQueuedEventExecutionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not execute queued event",
    details: ["The executor is busy."],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShelfQueuedEventExecutionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
