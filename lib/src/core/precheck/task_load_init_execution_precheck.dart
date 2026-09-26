import '__chk_code.dart';
import '__precheck.dart';

enum TaskLoadInitExcutionPrecheck implements Precheck {
  busy(
    precheckCode: PrecheckCode.busy,
    message: "The Task execution is disabled.",
    details: ["The executor is busy."],
  ),
  ;

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const TaskLoadInitExcutionPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}


