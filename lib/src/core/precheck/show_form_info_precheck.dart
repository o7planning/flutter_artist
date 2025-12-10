import '__chk_code.dart';
import '__precheck.dart';

enum ShowFormInfoPrecheck implements Precheck {
  noForm(
    precheckCode: PrecheckCode.noForm,
    message: "Can not show Form Info.",
    details: ["The block has no Form."],
  ),
  noLoggedInUser(
    precheckCode: PrecheckCode.noLoggedInUser,
    message: "Can not show Form Info.",
    details: ["The user is not logged in."],
  ),
  userIsNotSystemUser(
    precheckCode: PrecheckCode.permissionDenied,
    message: "Can not show Form Info.",
    details: ["The user is not a system user."],
  );

  @override
  final PrecheckCode precheckCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowFormInfoPrecheck({
    required this.precheckCode,
    required this.message,
    required this.details,
  });
}
