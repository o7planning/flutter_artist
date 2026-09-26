part of '../../core.dart';

abstract class StageFormModel<
        STAGE_ENUM extends Enum,
        INIT_DATA extends StageInitData,
        RESULT_DATA extends StageResultData,
        FLOW_CONTEXT_DATA extends FlowContextData,
        CREATION_PRESET extends CreationPreset,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<CREATION_PRESET, FORM_INPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  @override
  String get pathInfo =>
      "${stage.flow.activity.name} > ${stage.flow.name} > ${stage.name} > stage-form";

  late final Stage<STAGE_ENUM, INIT_DATA, RESULT_DATA, FLOW_CONTEXT_DATA,
      CREATION_PRESET, FORM_INPUT> stage;

  void _bindToStage(Stage parentStage) {
    stage = parentStage as Stage<STAGE_ENUM, INIT_DATA, RESULT_DATA,
        FLOW_CONTEXT_DATA, CREATION_PRESET, FORM_INPUT>;
  }

  StageFormModel({super.config});

  FLOW_CONTEXT_DATA get sharedContext => stage.sharedContext;

  // ===========================================================================
  // FORM EXTRACTION HOOKS
  // ===========================================================================

  /// Supplies baseline initial values derived from the Stage's [initData]
  /// and the Flow's [sharedContext].
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyInitialValuesForSimpleProps({
    required INIT_DATA initData,
    required FLOW_CONTEXT_DATA sharedContext,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyInitialValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required INIT_DATA initData,
    required FLOW_CONTEXT_DATA sharedContext,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleProps({
    required FORM_INPUT formInput,
  });

  @_AbstractMethodAnnotation()
  OptValueWrap? extractUpdateValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required FORM_INPUT formInput,
  });

  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required INIT_DATA initData,
    required FLOW_CONTEXT_DATA sharedContext,
  });

  // ===========================================================================
  // INITIALIZATION & SUBMIT
  // ===========================================================================

  /// Internal initializer invoked by [Stage.prepareStage].
  Future<void> _initStageForm({
    required INIT_DATA initData,
    required CREATION_PRESET creationPreset,
  }) async {
    _formModelStructure._clearFormError();
    _formModelStructure._setFormDataState(
      formDataState: FormDataStatePending(),
      error: null,
    );

    final additionalData = await performLoadAdditionalFormRelatedData(
      initData: initData,
      sharedContext: sharedContext,
    );

    final simpleDefaults = specifyInitialValuesForSimpleProps(
          initData: initData,
          sharedContext: sharedContext,
          creationPreset: creationPreset,
          additionalFormRelatedData: additionalData,
        ) ??
        {};

    for (final entry in simpleDefaults.entries) {
      _formModelStructure._setTempSimplePropValue(
        propName: entry.key,
        value: entry.value,
        setForInitial: true,
      );
    }

    _formModelStructure._updateTempToReal();
    _formModelStructure._setFormDataState(
      formDataState: const FormDataStateLoadedFresh(),
      error: null,
    );
    _formModelStructure._formInitialDataReady = true;
  }

  /// Submits current form fields and advances the stage within the workflow.
  Future<bool> submit() async {
    final Map<String, dynamic> formMapData =
        _formModelStructure._currentFormData;
    final ApiResult<StageExecutionResult<STAGE_ENUM, RESULT_DATA>> apiResult =
        await stage.performStageSubmit(
      formStageData: formMapData,
      initData: stage.initData!,
      sharedContext: sharedContext,
    );

    if (apiResult.isSuccess()) {
      await stage._processStageSubmitResult(apiResult);
      _formModelStructure._setManualDirty(false);
      return true;
    }
    return false;
  }

  @override
  bool isEnabled() => stage.dataState.isLoaded;

  @override
  bool _canResetForm() => isDirty();

  @override
  void _refreshAllViews() => stage.ui.refreshAllViews();

  @override
  void _triggerWhenFormViewVisible() {}

  @override
  void _addToRecent() {}

  @override
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {}
}
