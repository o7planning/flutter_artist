import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../flow/change_password_flow.dart';
import '../flow_data/change_password_data.dart';
import '../stage_data/new_password_stage_data.dart';

class EnterNewPasswordStage extends Stage<
    ChangePassEnum, // STAGE_ENUM
    NewPasswordStageData, // STAGE_DATA
    ChangePasswordData, // FLOW_CONTEXT_DATA
    EmptyFormInput, // FORM_INPUT
    EmptyAdditionalFormRelatedData // AdditionalFormRelatedData
    > {
  static const stageName = "enter-new-password-stage";

  EnterNewPasswordStage({required super.name, required super.config})
      : super(stageId: ChangePassEnum.enterNewPassword);

  @override
  Future<ApiResult<StageExecutionResult<ChangePassEnum, NewPasswordStageData>>>
      performStageSubmit({
    required Map<String, dynamic> formStageData,
    required ChangePasswordData sharedContext,
  }) {
    // TODO: implement performExecuteStage
    throw UnimplementedError();
  }
}
