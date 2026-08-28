import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../flow/change_password_flow.dart';
import '../flow_data/change_password_data.dart';
import '../stage_data/email_stage_data.dart';

class EnterEmailStage extends Stage<
    ChangePassEnum, // STAGE_ENUM
    EmailStageData, // STAGE_DATA
    ChangePasswordData, // FLOW_CONTEXT_DATA
    EmptyFormInput, // FORM_INPUT
    EmptyAdditionalFormRelatedData // AdditionalFormRelatedData
    > {
  static const stageName = "enter-email-stage";

  EnterEmailStage({
    required super.name,
    required super.config,
  }) : super(stageId: ChangePassEnum.enterEmail);

  @override
  Future<ApiResult<StageExecutionResult<ChangePassEnum, EmailStageData>>>
      performStageSubmit({
    required Map<String, dynamic> formStageData,
    required ChangePasswordData sharedContext,
  }) {
    // TODO: implement performStageSubmit
    throw UnimplementedError();
  }
}
