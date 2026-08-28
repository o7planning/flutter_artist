import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../flow/change_password_flow.dart';
import '../flow_data/change_password_data.dart';
import '../stage_data/otp_stage_data.dart';

class EnterOtpStage extends Stage<
    ChangePassEnum, // STAGE_ENUM
    OtpStageData, // STAGE_DATA
    ChangePasswordData, // FLOW_CONTEXT_DATA
    EmptyFormInput, // FORM_INPUT
    EmptyAdditionalFormRelatedData // AdditionalFormRelatedData
    > {
  static const stageName = "enter-otp-stage";

  EnterOtpStage({required super.name, required super.config})
      : super(stageId: ChangePassEnum.enterOtp);

  @override
  Future<ApiResult<StageExecutionResult<ChangePassEnum, OtpStageData>>>
      performStageSubmit({
    required Map<String, dynamic> formStageData,
    required ChangePasswordData sharedContext,
  }) {
    // TODO: implement performExecuteStage
    throw UnimplementedError();
  }
}
