part of '../../core.dart';

abstract class StageFormModel<
        STAGE_ENUM extends Enum,
        STAGE_DATA extends StageData,
        FLOW_CONTEXT_DATA extends FlowContextData,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel {
  Activity get activity => stage.flow.activity;

  Flow<STAGE_ENUM, FLOW_CONTEXT_DATA> get flow => stage.flow;

  @override
  String get pathInfo {
    return "${activity.name} > ${flow.name} > ${stage.stageId} > stage-form";
  }

  late final Stage<
      STAGE_ENUM, //
      STAGE_DATA,
      FLOW_CONTEXT_DATA,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> stage;

  void _bindToStage(
    Stage<
            STAGE_ENUM, //
            STAGE_DATA,
            FLOW_CONTEXT_DATA,
            FORM_INPUT,
            ADDITIONAL_FORM_RELATED_DATA>
        stage,
  ) {
    this.stage = stage;
  }

  /// Nạp dữ liệu phụ trợ cho bước này dựa trên sharedContext của cả Flow.
  Future<ADDITIONAL_FORM_RELATED_DATA?> performLoadStageFormData({
    required FLOW_CONTEXT_DATA sharedContext,
  });

  /// Điền giá trị khởi tạo cho form của bước này.
  Map<String, dynamic> specifyInitialValues({
    required FLOW_CONTEXT_DATA sharedContext,
    required ADDITIONAL_FORM_RELATED_DATA? relatedData,
  });

  // ***************************************************************************
  // ***************************************************************************

  @override
  void _addToRecent() {
    FlutterArtist.desk._addRecentActivity(activity);
  }

  @override
  void _triggerWhenFormViewVisible() {
    FlutterArtist.storage._lazyUiComponentTriggerQueue.addActivity(activity);
  }

  @override
  bool _canResetForm() {
    // Actionable canReset = block.canResetForm();
    // return canReset;
    // TODO: Hardcode
    print("TODO: stageFormModel._canResetForm");
    return false;
  }

  @override
  void _refreshAllViews() {
    // activity.ui.refreshAllViews();
    // TODO: Hardcode
    print("TODO: stageFormModel._refreshAllViews");
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Validate form tại bước này và đẩy kết quả sang stage.performStageSubmit
  Future<bool> submit() async {
    // final FormBuilderState? currentState = formKey.currentState;
    // if (currentState == null || !currentState.saveAndValidate()) {
    //   return;
    // }
    //
    // final Map<String, dynamic> formStageData = currentState.value;
    //
    // final apiResult = await stage.performStageSubmit(
    //   formStageData: formStageData,
    //   sharedContext: stage.flow.contextData,
    // );
    // await stage._processStageSubmitResult(apiResult);
    return true;
  }
}
