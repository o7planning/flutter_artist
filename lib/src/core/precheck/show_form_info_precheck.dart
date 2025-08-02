import '__chk_code.dart';
import '__precheck.dart';

enum ShowFormInfoPrecheck implements Precheck {
  noForm(
    chkCode: ChkCode.noForm,
    message: "Can not show Form Info.",
    details: ["The block has no Form."],
  ),
  noLoggedInUser(
    chkCode: ChkCode.noLoggedInUser,
    message: "Can not show Form Info.",
    details: ["The user is not logged in."],
  ),
  userIsNotSystemUser(
    chkCode: ChkCode.permissionDenied,
    message: "Can not show Form Info.",
    details: ["The user is not a system user."],
  );

  @override
  final ChkCode chkCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowFormInfoPrecheck({
    required this.chkCode,
    required this.message,
    required this.details,
  });
}
