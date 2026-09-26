import '../../../core.dart';

class NewPasswordStageData extends StageResultData {
  final String newPassword;
  final String confirmPassword;

  NewPasswordStageData({
    required this.newPassword,
    required this.confirmPassword,
  });
}
