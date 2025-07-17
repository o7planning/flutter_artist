part of '../../flutter_artist.dart';

enum ShowFormInfoState implements ECodeDetail {
  noForm(
    eCode: ECode.noForm,
    message: "Can not show Form Info.",
    details: ["The block has no Form."],
  ),
  noLoggedInUser(
    eCode: ECode.noLoggedInUser,
    message: "Can not show Form Info.",
    details: ["The user is not logged in."],
  ),
  userIsNotSystemUser(
    eCode: ECode.permissionDenied,
    message: "Can not show Form Info.",
    details: ["The user is not a system user."],
  ),
  ;

  @override
  final ECode eCode;

  @override
  final String message;

  @override
  final List<String>? details;

  const ShowFormInfoState({
    required this.eCode,
    required this.message,
    required this.details,
  });
}
