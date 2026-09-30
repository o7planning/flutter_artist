part of '../../core.dart';

/// Form model bound to an individual [Stage] within a multi-step [Prozess].
abstract class StageFormModel<
        STAGE_ENUM extends Enum,
        INIT_DATA extends StageInitData,
        RESULT_DATA extends StageResultData,
        PROZESS_CONTEXT_DATA extends ProzessContextData,
        CREATION_PRESET extends CreationPreset,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends ActivityFormModel<INIT_DATA, RESULT_DATA, CREATION_PRESET,
        FORM_INPUT, ADDITIONAL_FORM_RELATED_DATA> {
  late final Stage<STAGE_ENUM, INIT_DATA, RESULT_DATA, PROZESS_CONTEXT_DATA,
      CREATION_PRESET, FORM_INPUT> stage;

  @override
  Activity get activity => stage.activity;

  @override
  INIT_DATA? get initData => stage.initData;

  PROZESS_CONTEXT_DATA get sharedContext => stage.sharedContext;

  @override
  String get pathInfo =>
      "${activity.name} > ${stage.prozess.name} > ${stage.name} > stage-form";

  // ===========================================================================

  StageFormModel({super.config});

  // ===========================================================================

  @override
  String debugClassParametersDefinition() {
    return "<${getStageEnumType()}, ${getInitDataType()}, ${getResultDataType()}, ${getProzessContextDataType()}, "
        "${getCreationPresetType()}, ${getFormInputType()}, ${getAdditionalFormRelatedDataType()}>";
  }

  // ===========================================================================

  Type getStageEnumType() => STAGE_ENUM;
  Type getProzessContextDataType() => PROZESS_CONTEXT_DATA;

  // ===========================================================================

  void _bindToStage(
    Stage<STAGE_ENUM, INIT_DATA, RESULT_DATA, PROZESS_CONTEXT_DATA,
            CREATION_PRESET, FORM_INPUT>
        parentStage,
  ) {
    stage = parentStage;
  }

  XStageFormModel<
      STAGE_ENUM, //
      INIT_DATA,
      RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      CREATION_PRESET,
      FORM_INPUT> _createXStageFormModel({
    required FORM_INPUT? formInput,
  }) {
    return XStageFormModel<
        STAGE_ENUM, //
        INIT_DATA,
        RESULT_DATA,
        PROZESS_CONTEXT_DATA,
        CREATION_PRESET,
        FORM_INPUT>._(
      formModel: this,
      formInput: formInput,
    );
  }

  @override
  bool isEnabled() => !stage.isLoadingInitData && !stage.isSubmitting;

  @override
  void _refreshControlBars() => stage.ui.refreshControlBars();

  // ===========================================================================
  // EXECUTION INTENT DISPATCHERS & HANDLERS
  // ===========================================================================

  @override
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {
    final XActivity xActivity = _XActivityFormViewChange(formModel: this);
    XStage xStage = xActivity.findXStageByName(stage.name)!;
    xStage.xStageFormModel!._createAndSetFormModelExecutionIntentViewChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue(showOverlay: false);
  }

  @_ExecutionUnitMethodAnnotation()
  @_FormViewChangeAnnotation()
  Future<bool> _unitFormViewChanged({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XStageFormModel thisXStageFormModel,
    required FormModelViewChangeIntent executionIntent,
  }) async {
    __assertThisXStageFormModel(thisXStageFormModel);
    thisXStageFormModel._createAndSetFormModelExecutionIntentDone();

    executionIntent.resultWrapper._setResult(
      FormModelViewChangedResult(),
      objectCaller: this,
      methodName: '_unitFormViewChanged',
    );

    await _startNewFormActivity(
      executionTrace: executionTrace,
      creationPreset: null,
      formInput: null,
      activityType: FormActivityType.updateFromFormView,
      formKeyInstantValuesInUI: executionIntent.formKeyInstantValuesInUI,
    );
    return true;
  }

  @_ExecutionUnitMethodAnnotation()
  @_StageFormModelLoadDataAnnotation()
  Future<bool> _unitLoadFormData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XStageFormModel thisXStageFormModel,
    required FormModelDataLoadIntent executionIntent,
  }) async {
    __assertThisXStageFormModel(thisXStageFormModel);
    thisXStageFormModel._createAndSetFormModelExecutionIntentDone();

    executionIntent.resultWrapper._setResult(
      FormModelDataLoadResult(),
      objectCaller: this,
      methodName: '_unitLoadFormData',
    );

    final visibleX = ui.hasVisibleViews();
    final thisFormDataState = dataState;
    final bool forceReloadForm = switch (thisXStageFormModel.formLoadHint) {
      FormLoadHint.force => true,
      FormLoadHint.forceIfNeed => (thisFormDataState.isPending ||
          thisFormDataState.isFatalError ||
          thisFormDataState.isStale),
      FormLoadHint.auto => visibleX &&
          (thisFormDataState.isPending ||
              thisFormDataState.isFatalError ||
              thisFormDataState.isStale),
    };

    if (!forceReloadForm) {
      if (!dataState.isLoaded) {
        _clearDataWithDataState(formDataState: const FormDataStatePending());
      }
      return true;
    }

    final formInput = thisXStageFormModel.formInput as FORM_INPUT?;
    return await _startNewFormActivity(
      executionTrace: executionTrace,
      creationPreset: null,
      formInput: formInput,
      activityType: FormActivityType.startCreatingOrEditing,
      formKeyInstantValuesInUI: null,
    );
  }

  @_ExecutionUnitMethodAnnotation()
  @_FormModelPatchFormFieldsAnnotation()
  Future<bool> _unitPatchFormFields({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XStageFormModel thisXStageFormModel,
    required FormModelPatchFormFieldsIntent<FORM_INPUT> executionIntent,
  }) async {
    __assertThisXStageFormModel(thisXStageFormModel);
    thisXStageFormModel._createAndSetFormModelExecutionIntentDone();

    executionIntent.resultWrapper._setResult(
      FormModelPatchFormFieldsResult(),
      objectCaller: this,
      methodName: '_unitPatchFormFields',
    );

    await _startNewFormActivity(
      executionTrace: executionTrace,
      creationPreset: null,
      formInput: executionIntent.formInput,
      activityType: FormActivityType.patchFormFields,
      formKeyInstantValuesInUI: null,
    );
    return true;
  }

  @_RootMethodAnnotation()
  @_FormModelPatchFormFieldsAnnotation()
  Future<FormModelPatchFormFieldsResult> patchFormFields({
    required FORM_INPUT formInput,
  }) async {
    final Actionable<FormModelPatchFormFieldsPrecheck> actionable =
        __canPatchFormFields(checkBusy: true);
    if (!actionable.yes) {
      _addErrorLogActionable(
        shelf: null,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormModelPatchFormFieldsResult(precheck: actionable.errCode);
    }

    final XActivity xActivity =
        _XActivityFormModelPatchFormFields(formModel: this);
    XStage xStage = xActivity.findXStageByName(stage.name)!;
    final executionIntent = xStage.xStageFormModel!
        ._createAndSetFormModelExecutionIntentPatchFormFields<FORM_INPUT>(
            formInput: formInput);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  void __assertThisXStageFormModel(XStageFormModel thisXStageFormModel) {
    if (!identical(thisXStageFormModel.formModel, this)) {
      throw "Error Assert form model: ${thisXStageFormModel.formModel} - $this";
    }
  }
}
