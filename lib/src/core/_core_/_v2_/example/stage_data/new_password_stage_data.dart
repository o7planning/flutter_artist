import '../../../../../../flutter_artist.dart';

class NewPasswordStageData extends StageData {
  final String newPassword;
  final String confirmPassword;

  NewPasswordStageData({
    required this.newPassword,
    required this.confirmPassword,
  });
}
