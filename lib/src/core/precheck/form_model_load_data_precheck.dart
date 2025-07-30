import '../annotation/annotation.dart';
import '__chk_code.dart';
import '__chk_code_detail.dart';

@RenameAnnotation("FormModelDataLoadPrecheck")
enum FormModelLoadDataPrecheck implements ChkCodeDetail {
  busy(
    chkCode: ChkCode.busy,
    message: "Can not load form data.",
    details: ["The executor is busy."],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const FormModelLoadDataPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
