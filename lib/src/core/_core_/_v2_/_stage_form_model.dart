part of '../core.dart';

/// Mô hình quản lý biểu mẫu và validation chuyên biệt cho Stage.
abstract class StageFormModel<
STAGE_DATA extends StageData,
FORM_INPUT extends FormInput,
ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData> extends _Core {
  late final Stage<
      Enum, //
      STAGE_DATA,
      FlowContextData,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> stage;

  void _bindToStage(Stage<
      Enum, //
      STAGE_DATA,
      FlowContextData,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA>
  stage) {
    this.stage = stage;
  }

  /// Thu thập dữ liệu và kích hoạt luồng Submit của Stage.
  Future<void> submit() async {
    // Thu thập dữ liệu biểu mẫu đã nhập
    Map<String, dynamic> formStageData = {};

    final apiResult = await stage.performStageSubmit(
      formStageData: formStageData,
      sharedContext: stage.flow._flowContextData,
    );
    await stage._processStageSubmitResult(apiResult);
  }
}
