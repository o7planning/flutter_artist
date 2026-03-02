import '__chk_code.dart';
import '__precheck.dart';

enum ShelfDeferredEventExecutionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "Can not execute deferred event",
    details: ["The executor is busy."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShelfDeferredEventExecutionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
