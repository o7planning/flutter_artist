import '../../../../../../flutter_artist.dart';
import '../stage_data/email_stage_data.dart';
import '../stage_data/new_password_stage_data.dart';
import '../stage_data/otp_stage_data.dart';

class ChangePasswordData extends FlowContextData {
  EmailStageData? enterEmailStageData;
  OtpStageData? enterOtpStageData;
  NewPasswordStageData? enterNewPasswordStageData;
}
