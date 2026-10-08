part of '__built_in_model.dart';

class DefaultStage<
        STAGE_ENUM extends StageEnum, //
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends Stage<STAGE_ENUM, EmptyStageInitData, EmptyStageResultData,
        PROZESS_CONTEXT_DATA, FormInput, FormOutput> {
  final Future<ApiResult<EmptyStageInitData>> Function({
    required PROZESS_CONTEXT_DATA sharedContext,
  })? onLoadInit;

  final Future<ApiResult<EmptyStageResultData>> Function({
    required EmptyStageInitData initData,
    required PROZESS_CONTEXT_DATA sharedContext,
  })? onSubmit;

  final STAGE_ENUM Function({
    required PROZESS_CONTEXT_DATA prozessContextData,
    required EmptyStageResultData stageDataResult,
  })? onDetermineNextStage;

  DefaultStage({
    required super.stageId,
    required super.name,
    this.onLoadInit,
    this.onSubmit,
    this.onDetermineNextStage,
    super.formModel,
  });

  @override
  Future<ApiResult<EmptyStageInitData>> performLoadInitData(
      {required PROZESS_CONTEXT_DATA sharedContext}) async {
    if (onLoadInit != null) {
      return onLoadInit!(sharedContext: sharedContext);
    }
    return ApiResult.success(data: EmptyStageInitData());
  }

  @override
  Future<ApiResult<EmptyStageResultData>> performSubmit({
    required EmptyStageInitData initData,
    required PROZESS_CONTEXT_DATA sharedContext,
    required FormOutput? formData,
  }) async {
    if (onSubmit != null) {
      return onSubmit!(initData: initData, sharedContext: sharedContext);
    }
    return ApiResult.success(data: EmptyStageResultData());
  }

  @override
  StageEnum? determineNextStage({
    required PROZESS_CONTEXT_DATA prozessContextData,
    required EmptyStageResultData stageDataResult,
  }) {
    if (onDetermineNextStage != null) {
      return onDetermineNextStage!(
          prozessContextData: prozessContextData,
          stageDataResult: stageDataResult);
    }
    return null;
  }
}
