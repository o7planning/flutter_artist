import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../../../../flutter_artist.dart';
import '../flow_data/change_password_data.dart';
import '../stage/enter_email_stage.dart';
import '../stage/enter_new_password_stage.dart';
import '../stage/enter_otp_stage.dart';

enum ChangePassEnum {
  enterEmail,
  enterOtp,
  enterNewPassword;
}

class ChangePasswordFlow extends Flow<ChangePassEnum, ChangePasswordData> {
  static const String flowName = "change-password-flow";

  ChangePasswordFlow({required super.name});

  @override
  FlowStructure<ChangePassEnum, ChangePasswordData> defineFlowStructure() {
    return FlowStructure<ChangePassEnum, ChangePasswordData>(
      initialStageId: ChangePassEnum.enterEmail,
      stages: [
        EnterEmailStage(
          name: EnterEmailStage.stageName,
          config: StageConfig(),
        ),
        EnterOtpStage(
          name: EnterOtpStage.stageName,
          config: StageConfig(),
        ),
        EnterNewPasswordStage(
          name: EnterNewPasswordStage.stageName,
          config: StageConfig(),
        ),
      ],
    );
  }

  @override
  Future<ApiResult<ChangePasswordData>> performLoadFlowContextData() async {
    return ApiResult.success(data: ChangePasswordData());
  }
}
