part of '../../core.dart';

/// Form model specifically bound to a standalone [Task].
abstract class TaskFormModel<
        INIT_DATA extends TaskInitData,
        RESULT_DATA extends TaskResultData,
        FORM_INPUT extends FormInput,
        FORM_OUTPUT extends FormOutput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends WorkNodeFormModel<
        INIT_DATA, //
        RESULT_DATA,
        FORM_INPUT,
        FORM_OUTPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  late final Task<INIT_DATA, RESULT_DATA, FORM_INPUT, FORM_OUTPUT> task;

  @override
  Task get host => task;

  @override
  Activity get activity => task.activity;

  @override
  Activity get module => task.module;

  @override
  INIT_DATA? get initData => task.initData;

  @override
  String get pathInfo => "${activity.name} > ${task.name} > task-form";

  // ===========================================================================

  TaskFormModel({super.config});

  // ===========================================================================

  @override
  String debugClassParametersDefinition() {
    return "<${getInitDataType()}, ${getResultDataType()}, "
        "${getFormInputType()}, ${getAdditionalFormRelatedDataType()}>";
  }

  // ===========================================================================

  void _bindToTask(
    Task<INIT_DATA, RESULT_DATA, FORM_INPUT, FORM_OUTPUT> parentTask,
  ) {
    task = parentTask;
  }

  XTaskFormModel<INIT_DATA, RESULT_DATA> _createXTaskFormModel({
    required FORM_INPUT? formInput,
  }) {
    return XTaskFormModel<INIT_DATA, RESULT_DATA>._(
      formModel: this,
      formInput: formInput,
    );
  }

  @override
  bool isEnabled() {
    if (!host.isStateReadyForForm()) {
      return false;
    }
    // Check if the underlying Form Model data state forbids modifications
    if (dataState.isNone || dataState.isFatalError) {
      return false;
    }
    // Check if the Task (FormHost) is currently busy executing network calls
    if (task.isLoadingInitData || task.isSubmitting) {
      return false;
    }
    // Check if the Task has already been successfully submitted.
    // Once successfully completed, the form inputs should be locked from further edits.
    if (task.dataState.isSubmissionAttemptedSuccess) {
      return false;
    }
    return true;
  }

  @override
  void _refreshControlBars() => task.ui.refreshControlBars();

  // ===========================================================================
  // EXECUTION INTENT DISPATCHERS & HANDLERS
  // ===========================================================================

  @override
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {
    final XActivity xActivity = _XActivityFormViewChange(formModel: this);
    XTask xTask = xActivity.findXTaskByName(task.name)!;
    xTask.xTaskFormModel!._createAndSetFormModelExecutionIntentViewChange(
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
    required XTaskFormModel thisXTaskFormModel,
    required FormModelViewChangeIntent executionIntent,
  }) async {
    __assertThisXTaskFormModel(thisXTaskFormModel);
    thisXTaskFormModel._createAndSetFormModelExecutionIntentDone();

    executionIntent.resultWrapper._setResult(
      FormModelViewChangedResult(),
      objectCaller: this,
      methodName: '_unitFormViewChanged',
    );

    await _startNewFormActivity(
      executionTrace: executionTrace,
      formInput: null,
      activityType: FormActivityType.updateFromFormView,
      formKeyInstantValuesInUI: executionIntent.formKeyInstantValuesInUI,
    );
    return true;
  }

  @_ExecutionUnitMethodAnnotation()
  @_TaskFormModelLoadDataAnnotation()
  Future<bool> _unitLoadFormData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XTaskFormModel thisXTaskFormModel,
    required FormModelDataLoadIntent executionIntent,
  }) async {
    __assertThisXTaskFormModel(thisXTaskFormModel);
    thisXTaskFormModel._createAndSetFormModelExecutionIntentDone();

    executionIntent.resultWrapper._setResult(
      FormModelDataLoadResult(),
      objectCaller: this,
      methodName: '_unitLoadFormData',
    );

    final visibleX = ui.hasVisibleViews();
    final thisFormDataState = dataState;
    final bool forceReloadForm = switch (thisXTaskFormModel.formLoadHint) {
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

    final formInput = thisXTaskFormModel.formInput as FORM_INPUT?;
    return await _startNewFormActivity(
      executionTrace: executionTrace,
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
    required XTaskFormModel thisXTaskFormModel,
    required FormModelPatchFormFieldsIntent<FORM_INPUT> executionIntent,
  }) async {
    __assertThisXTaskFormModel(thisXTaskFormModel);
    thisXTaskFormModel._createAndSetFormModelExecutionIntentDone();

    executionIntent.resultWrapper._setResult(
      FormModelPatchFormFieldsResult(),
      objectCaller: this,
      methodName: '_unitPatchFormFields',
    );

    await _startNewFormActivity(
      executionTrace: executionTrace,
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
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "patchFormFields",
      parameters: null,
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    executionTrace.addNonControllableCall(
      codeId: "#112000",
      caller: this,
      methodName: "__checkBeforePatchFormFields",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );

    final Actionable<FormModelPatchFormFieldsPrecheck> actionable =
        __checkBeforePatchFormFields(
      checkBusy: checkBusyTrue,
    );
    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#112100",
        prefixShortDesc: '__checkBeforePatchFormFields()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormModelPatchFormFieldsResult(precheck: actionable.errCode);
    }

    final XActivity xActivity =
        _XActivityFormModelPatchFormFields(formModel: this);
    XTask xTask = xActivity.findXTaskByName(task.name)!;
    final executionIntent = xTask.xTaskFormModel!
        ._createAndSetFormModelExecutionIntentPatchFormFields<FORM_INPUT>(
            formInput: formInput);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  void __assertThisXTaskFormModel(XTaskFormModel thisXTaskFormModel) {
    if (!identical(thisXTaskFormModel.formModel, this)) {
      throw "Error Assert form model: ${thisXTaskFormModel.formModel} - $this";
    }
  }
}
