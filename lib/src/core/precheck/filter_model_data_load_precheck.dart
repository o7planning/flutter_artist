import '__chk_code.dart';
import '__precheck.dart';

enum FilterModelDataLoadPrecheck implements Precheck {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not load filter data.",
    details: ["The executor is busy."],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FilterModelDataLoadPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
