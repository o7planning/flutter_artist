import '__chk_code.dart';
import '__precheck.dart';

enum ShelfDelayedReactionExecutionPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not execute delayed reaction",
    details: ["The executor is busy."],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShelfDelayedReactionExecutionPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
