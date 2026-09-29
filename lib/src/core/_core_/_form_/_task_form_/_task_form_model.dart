part of '../../core.dart';

abstract class TaskFormModel<
INIT_DATA extends TaskInitData,
RESULT_DATA extends TaskResultData,
CREATION_PRESET extends CreationPreset,
FORM_INPUT extends FormInput,
ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<
        CREATION_PRESET, //
        FORM_INPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  @override
  String get pathInfo {
    return "${activity.name} > ${task.name} > task-form";
  }

  ADDITIONAL_FORM_RELATED_DATA? _additionalFormRelatedData;
  FORM_INPUT? _creationFormInput;

  Activity get activity => task.activity;

  late final Task<INIT_DATA, RESULT_DATA, CREATION_PRESET, FORM_INPUT> task;

  bool _defaultSimpleValuesInitiated = false;
  bool _defaultMultiOptValuesInitiated = false;

  bool get defaultSimpleValuesInitiated => _defaultSimpleValuesInitiated;

  bool get defaultMultiOptValuesInitiated => _defaultMultiOptValuesInitiated;

  // ***************************************************************************
  // ***************************************************************************

  TaskFormModel({
    super.config,
  });

  void _bindToTask(
      Task<INIT_DATA, RESULT_DATA, CREATION_PRESET, FORM_INPUT> parentTask,) {
    task = parentTask;
  }

  // ***************************************************************************

  XTaskFormModel<INIT_DATA, RESULT_DATA> _createXTaskFormModel({
    required FORM_INPUT? formInput,
  }) {
    return XTaskFormModel<INIT_DATA, RESULT_DATA>._(
      formModel: this,
      formInput: formInput,
    );
  }

  // ***************************************************************************

  Type getFormRelatedDataType() {
    return ADDITIONAL_FORM_RELATED_DATA;
  }

  Type getCreationPresetType() {
    return CREATION_PRESET;
  }

  Type getInitDataType() => INIT_DATA;

  Type getResultDataType() => RESULT_DATA;

  Type getFormInputType() => FORM_INPUT;

  // ***************************************************************************

  void __disableAutovalidation() {
    AutovalidateMode temp = _autovalidateMode;
    _autovalidateMode = AutovalidateMode.disabled;
    ui.refreshAllViews(force: true);
    _autovalidateMode = temp;
  }

  // ***************************************************************************
  // *** ABSTRACT METHODS: DATA EXTRACTION & FORM MUTATION ********************
  // ***************************************************************************

  /// Loads dynamic option dataset ([XData]) for a multi-option form property.
  @_AbstractMethodAnnotation()
  Future<XData?> performLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required INIT_DATA? initData,
  });

  // ===========================================================================
  // PAIR 1: CREATION / DEFAULT PHASE (Evaluated when initData is absent)
  // ===========================================================================

  /// Supplies baseline initial values for simple form properties.
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyCreationValuesForSimpleProps({
    required CREATION_PRESET? creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  /// Resolves the initial selection wrapper for a multi-option property.
  @_AbstractMethodAnnotation()
  OptValueWrap? specifyCreationValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required CREATION_PRESET? creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  // ===========================================================================
  // PAIR 2: INITIAL DATA EXTRACTION PHASE (Evaluated when initData is present)
  // ===========================================================================

  /// Extracts values from the loaded [initData] to populate simple form fields.
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? extractSimplePropValuesFromInitData({
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required INIT_DATA initData,
  });

  /// Extracts selection wrappers from the loaded [initData] for a multi-option property.
  @_AbstractMethodAnnotation()
  OptValueWrap? extractMultiOptPropValueFromInitData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required INIT_DATA initData,
  });

  // ===========================================================================
  // PAIR 3: EXTERNAL DIRECTIVES (FORM INPUT)
  // ===========================================================================

  /// Extracts override values from an external [formInput] for simple form fields.
  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleProps({
    required FORM_INPUT formInput,
  });

  /// Extracts override values from an external [formInput] for a multi-option property.
  @_AbstractMethodAnnotation()
  OptValueWrap? extractUpdateValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required FORM_INPUT formInput,
  });

  // ===========================================================================
  // AUXILIARY REMOTE OPERATIONS
  // ===========================================================================

  /// Asynchronously fetches auxiliary metadata specifically required for form display.
  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required INIT_DATA? initData,
  });

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  String get debugClassDefinition =>
      "${getClassName(this)}$debugClassParametersDefinition";

  @DebugMethodAnnotation()
  String get debugClassParametersDefinition =>
      "<${getInitDataType()}, ${getResultDataType()}, ${getFormInputType()}>";

  // ***************************************************************************
  // ***************************************************************************

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

    executionTrace.addInfo(
      codeId: "#96000",
      shortDesc:
      "Begin ${debugObjHtml(this)} -> ${executionUnitType
          .asDebugExecutionUnit()}.",
    );
    final executionResult = executionIntent.resultWrapper._setResult(
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

  // ***************************************************************************
  // ***************************************************************************

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

    executionTrace.addInfo(
      codeId: "#97000",
      shortDesc:
      "Begin ${debugObjHtml(this)} -> ${executionUnitType
          .asDebugExecutionUnit()}.",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      FormModelDataLoadResult(),
      objectCaller: this,
      methodName: '_unitLoadFormData',
    );

    final visibleX = ui.hasVisibleViews();
    final thisFormDataState = dataState;
    final bool forceReloadForm;
    switch (thisXTaskFormModel.formLoadHint) {
      case FormLoadHint.force:
        forceReloadForm = true;
      case FormLoadHint.forceIfNeed:
        forceReloadForm = (thisFormDataState.isPending ||
            thisFormDataState.isFatalError ||
            thisFormDataState.isStale);
      case FormLoadHint.auto:
        forceReloadForm = visibleX &&
            (thisFormDataState.isPending ||
                thisFormDataState.isFatalError ||
                thisFormDataState.isStale);
    }

    executionTrace.addInfo(
      codeId: "#97060",
      shortDesc:
      "Calculate >> @forceReloadForm: ${debugObjHtml(forceReloadForm)}",
    );

    if (!forceReloadForm) {
      if (!dataState.isLoaded) {
        executionTrace.addInfo(
          codeId: "#97100",
          shortDesc:
          "${debugObjHtml(this)} - @dataState: ${debugObjHtml(
              dataState)} --> Clear data and set to <b>pending</b>.",
        );
        _clearDataWithDataState(formDataState: FormDataStatePending());
      }
      executionTrace.addInfo(
        codeId: "#97120",
        shortDesc:
        "@forceReloadForm: ${debugObjHtml(forceReloadForm)} --> do nothing.",
      );
      return true;
    }

    final formInput = thisXTaskFormModel.formInput as FORM_INPUT?;
    final activityType = FormActivityType.startCreatingOrEditing;

    executionTrace.addNonControllableCall(
      codeId: "#97260",
      caller: this,
      methodName: "_startNewFormActivity",
      suffixShortDesc: "",
      parameters: {
        "activityType": activityType,
        "formInput": formInput,
      },
    );

    return await _startNewFormActivity(
      executionTrace: executionTrace,
      creationPreset: null,
      formInput: formInput,
      activityType: activityType,
      formKeyInstantValuesInUI: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

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

    executionTrace.addInfo(
      codeId: "#98000",
      shortDesc:
      "Begin ${debugObjHtml(this)} -> ${executionUnitType
          .asDebugExecutionUnit()}.",
    );
    final executionResult = executionIntent.resultWrapper._setResult(
      FormModelPatchFormFieldsResult(),
      objectCaller: this,
      methodName: '_unitPatchFormFields',
    );

    final activityType = FormActivityType.patchFormFields;

    executionTrace.addNonControllableCall(
      codeId: "#98100",
      caller: this,
      methodName: "_startNewFormActivity",
      suffixShortDesc: "",
      parameters: {
        "activityType": activityType,
        "formInput": executionIntent.formInput,
      },
    );

    await _startNewFormActivity(
      executionTrace: executionTrace,
      creationPreset: null,
      formInput: executionIntent.formInput,
      activityType: activityType,
      formKeyInstantValuesInUI: null,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Central lifecycle coordinator for Form data mutation, initialization, and validation.
  @_ImportantMethodAnnotation(
      "Called when Form Data is being loaded or user makes changes in FormView")
  Future<bool> _startNewFormActivity({
    required ExecutionTrace executionTrace,
    required CREATION_PRESET? creationPreset,
    required FORM_INPUT? formInput,
    required final FormActivityType activityType,
    required Map<String, dynamic>? formKeyInstantValuesInUI,
  }) async {
    debug._formActivityCount++;

    executionTrace.addInfo(
      codeId: "#96000",
      shortDesc: "${debugObjHtml(this)} on _startNewFormActivity().",
    );

    if (activityType == FormActivityType.startCreatingOrEditing) {
      debug._loadCount++;
      _autovalidateMode = config.autovalidateMode;
    } else {
      _autovalidateMode = config.autovalidateMode;
    }

    final INIT_DATA? initData = task.initData;
    final FormMode currentFormMode;
    ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData;

    switch (activityType) {
      case FormActivityType.startCreatingOrEditing:
        currentFormMode = initData == null ? FormMode.creation : FormMode.edit;

        _formModelStructure._clearFormError();
        _formModelStructure._setFormDataState(
          formDataState: FormDataStatePending(),
          error: null,
        );

        if (currentFormMode == FormMode.creation) {
          _creationFormInput = formInput;
        } else {
          _creationFormInput = null;
        }

        // Asynchronously load auxiliary data required by this form model
        additionalFormRelatedData =
        await _performLoadAdditionalFormRelatedData(executionTrace);
        if (additionalFormRelatedData == null) {
          return false;
        }
        _additionalFormRelatedData = additionalFormRelatedData;
        break;

      case FormActivityType.updateFromFormView:
        currentFormMode = formMode;
        if (formInput != null) {
          throw DevError(
            errorMessage:
            "Dev Error. formInput must be null if FormModel.activityType = updateFromFormView.",
          );
        }
        if (currentFormMode == FormMode.creation) {
          formInput = _creationFormInput;
        }
        additionalFormRelatedData = _additionalFormRelatedData;
        if (additionalFormRelatedData == null) {
          throw DevError(
            errorMessage:
            "Dev Error. _additionalFormRelatedData is null in updateFromFormView.",
          );
        }
        break;

      case FormActivityType.patchFormFields:
        currentFormMode = formMode;
        if (formInput == null) {
          throw DevError(
            errorMessage:
            "Dev Error. formInput must be not null if FormModel.activityType = patchFormFields.",
          );
        }
        additionalFormRelatedData = _additionalFormRelatedData;
        if (additionalFormRelatedData == null) {
          throw DevError(
            errorMessage:
            "Dev Error. _additionalFormRelatedData is null in patchFormFields.",
          );
        }
        break;
    }

    _formModelStructure._setFormMode(currentFormMode);
    final bool isNoneMode = currentFormMode == FormMode.none;
    final bool isCreationMode = currentFormMode == FormMode.creation;

    if (activityType == FormActivityType.startCreatingOrEditing) {
      if (isNoneMode || isCreationMode) {
        _defaultSimpleValuesInitiated = false;
        _defaultMultiOptValuesInitiated = false;
      }
    }

    final Map<String, dynamic> formKeyInstantValues =
        formKeyInstantValuesInUI ?? _formModelStructure._currentFormData;

    _formModelStructure._setupTemporaryStateForNewActivity(
      activityType: activityType,
      formKeyInstantValues: formKeyInstantValues,
    );

    // =========================================================================
    // POPULATE SIMPLE PROPERTIES
    // =========================================================================
    if (activityType == FormActivityType.startCreatingOrEditing) {
      // -----------------------------------------------------------------------
      // CASE 1: LOADED INIT DATA PRESENT (initData != null) -> Read values
      // -----------------------------------------------------------------------
      if (initData != null) {
        executionTrace.addInfo(
          codeId: "#96180",
          shortDesc: "Populating form from Task INIT_DATA."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @initData: ${debugObjHtml(initData)}.",
        );
        try {
          executionTrace.addControllableCall(
            codeId: "#96200",
            caller: this,
            methodName: "extractSimplePropValuesFromInitData",
            suffixShortDesc: "",
            parameters: {
              "additionalFormRelatedData": additionalFormRelatedData,
              "initData": initData,
            },
          );
          final simplePropValueMap = extractSimplePropValuesFromInitData(
            additionalFormRelatedData: additionalFormRelatedData,
            initData: initData,
          ) ??
              {};

          for (String propName in simplePropValueMap.keys) {
            __throwErrorIfNotASimplePropName(
              propName: propName,
              formErrorMethod:
              FormErrorMethod.extractSimplePropValuesFromItemDetail,
            );
            dynamic value = simplePropValueMap[propName];
            _formModelStructure._setTempSimplePropValue(
              propName: propName,
              value: value,
              setForInitial: true,
            );
          }
        } catch (e, stackTrace) {
          dynamic error = e;
          if (e is FormPropTypeMismatchError) {
            error = e.toAppError(
              formModelName: getClassNameWithoutGenerics(this),
            );
          }
          final formErrorInfo = FormErrorInfo(
            activityType: activityType,
            propName: null,
            formErrorMethod:
            FormErrorMethod.extractSimplePropValuesFromItemDetail,
            error: error,
            errorStackTrace: stackTrace,
          );
          _formModelStructure._setFormError(formErrorInfo);

          final ErrorInfo errorInfo = _handleError(
            shelf: null,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
            tipDocument: null,
          );

          final fatalErrorInfo = FormDataStateFatalError(errorInfo: errorInfo);
          __endFormActivityWithDataState(
            formDataState: fatalErrorInfo,
            activityType: activityType,
            error: e,
          );
          executionTrace.addInfo(
            codeId: "#96400",
            shortDesc:
            "The ${debugObjHtml(
                this)}.extractSimplePropValuesFromInitData() method was called with an error!",
            errorInfo: errorInfo,
          );
          return false;
        }
      }
      // -----------------------------------------------------------------------
      // CASE 2: CREATION / DEFAULT MODE (initData == null) -> Pull defaults
      // -----------------------------------------------------------------------
      else {
        executionTrace.addInfo(
          codeId: "#96500",
          shortDesc: "Initial creation defaults in Task form."
              "\n - @activityType: <b>$activityType</b>.",
        );

        if (!_defaultSimpleValuesInitiated) {
          try {
            executionTrace.addControllableCall(
              codeId: "#96540",
              caller: this,
              methodName: "specifyCreationValuesForSimpleProps",
              suffixShortDesc: "",
              parameters: {
                "creationPreset": creationPreset,
                "additionalFormRelatedData": additionalFormRelatedData,
              },
            );

            final Map<String, dynamic> simplePropValueDefault =
                specifyCreationValuesForSimpleProps(
                  creationPreset: creationPreset,
                  additionalFormRelatedData: additionalFormRelatedData,
                ) ??
                    {};

            for (String propName in simplePropValueDefault.keys) {
              __throwErrorIfNotASimplePropName(
                propName: propName,
                formErrorMethod:
                FormErrorMethod.specifyDefaultValuesForSimpleProps,
              );
              dynamic value = simplePropValueDefault[propName];
              _formModelStructure._setTempSimplePropValue(
                propName: propName,
                value: value,
                setForInitial: true,
              );
            }
          } catch (e, stackTrace) {
            final formErrorInfo = FormErrorInfo(
              activityType: activityType,
              propName: null,
              formErrorMethod:
              FormErrorMethod.specifyDefaultValuesForSimpleProps,
              error: e,
              errorStackTrace: stackTrace,
            );
            _formModelStructure._setFormError(formErrorInfo);

            final ErrorInfo errorInfo = _handleError(
              shelf: null,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
              tipDocument: null,
            );

            final fatalErrorState =
            FormDataStateFatalError(errorInfo: errorInfo);
            __endFormActivityWithDataState(
              formDataState: fatalErrorState,
              activityType: activityType,
              error: e,
            );
            return false;
          }
        }

        // Apply external FormInput overrides if present
        if (formInput != null) {
          try {
            executionTrace.addControllableCall(
              codeId: "#96620",
              caller: this,
              methodName: "extractUpdateValuesForSimpleProps",
              suffixShortDesc: "",
              parameters: {
                "formInput": formInput,
              },
            );
            final Map<String, SimpleValueWrap?> updatedSimplePropValues =
                extractUpdateValuesForSimpleProps(
                  formInput: formInput,
                ) ??
                    {};

            for (String propName in updatedSimplePropValues.keys) {
              __throwErrorIfNotASimplePropName(
                propName: propName,
                formErrorMethod:
                FormErrorMethod.extractUpdateValuesForSimpleProps,
              );
              SimpleValueWrap? valueWrap = updatedSimplePropValues[propName];
              if (valueWrap != null && valueWrap.use) {
                _formModelStructure._setTempSimplePropValue(
                  propName: propName,
                  value: valueWrap.value,
                  setForInitial: true,
                );
              }
            }
          } catch (e, stackTrace) {
            final formErrorInfo = FormErrorInfo(
              activityType: activityType,
              propName: null,
              formErrorMethod:
              FormErrorMethod.extractUpdateValuesForSimpleProps,
              error: e,
              errorStackTrace: stackTrace,
            );
            _formModelStructure._setFormError(formErrorInfo);

            final ErrorInfo errorInfo = _handleError(
              shelf: null,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
              tipDocument: null,
            );

            final fatalErrorState =
            FormDataStateFatalError(errorInfo: errorInfo);
            __endFormActivityWithDataState(
              formDataState: fatalErrorState,
              error: e,
              activityType: activityType,
            );
            return false;
          }
        }
      }
    }
    // -------------------------------------------------------------------------
    // CASE 3: PATCH FORM FIELDS
    // -------------------------------------------------------------------------
    else if (activityType == FormActivityType.patchFormFields) {
      if (formInput != null) {
        try {
          executionTrace.addControllableCall(
            codeId: "#96720",
            caller: this,
            methodName: "extractUpdateValuesForSimpleProps",
            suffixShortDesc: "",
            parameters: {
              "formInput": formInput,
            },
          );
          final Map<String, SimpleValueWrap?> updatedSimplePropValues =
              extractUpdateValuesForSimpleProps(
                formInput: formInput,
              ) ??
                  {};

          for (String propName in updatedSimplePropValues.keys) {
            __throwErrorIfNotASimplePropName(
              propName: propName,
              formErrorMethod:
              FormErrorMethod.extractUpdateValuesForSimpleProps,
            );
            SimpleValueWrap? valueWrap = updatedSimplePropValues[propName];
            if (valueWrap != null && valueWrap.use) {
              _formModelStructure._setTempSimplePropValue(
                propName: propName,
                value: valueWrap.value,
                setForInitial: false,
              );
            }
          }
        } catch (e, stackTrace) {
          final formErrorInfo = FormErrorInfo(
            activityType: activityType,
            propName: null,
            formErrorMethod: FormErrorMethod.extractUpdateValuesForSimpleProps,
            error: e,
            errorStackTrace: stackTrace,
          );
          _formModelStructure._setFormError(formErrorInfo);

          final ErrorInfo transientErrorInfo = _handleError(
            shelf: null,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
            tipDocument: null,
          );

          final formDataState = FormDataStateLoadedStale.failed(
            errorInfo: transientErrorInfo,
          );
          __endFormActivityWithDataState(
            formDataState: formDataState,
            activityType: activityType,
            error: e,
          );
          return false;
        }
      }
    }

    // =========================================================================
    // POPULATE MULTI-OPTION PROPERTIES (CASCADE HIERARCHY)
    // =========================================================================
    try {
      for (MultiOptFormPropModel multiOptProp
      in _formModelStructure._rootOptPropModels) {
        executionTrace.addNonControllableCall(
          codeId: "#96780",
          caller: task,
          methodName: "_loadMultiOptPropDataCascade",
          suffixShortDesc:
          "To load data for ${debugObjHtml(multiOptProp)} and its descendants.",
          parameters: {
            "additionalFormRelatedData": additionalFormRelatedData,
            "creationPreset": creationPreset,
            "formInput": formInput,
            "parentMultiOptPropValue": null,
            "parentValueIsInitialValue": true,
            "multiOptProp": multiOptProp,
            "formKeyInstantValues": formKeyInstantValues,
            "activityType": activityType,
          },
        );

        await _loadMultiOptPropDataCascade(
          executionTrace: executionTrace,
          creationPreset: creationPreset,
          additionalFormRelatedData: additionalFormRelatedData,
          formInput: formInput,
          parentMultiOptPropValue: null,
          parentValueIsInitialValue: true,
          multiOptProp: multiOptProp,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      final FormErrorInfo formErrorInfo;
      if (e is FormMethodError) {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: e.propName,
          formErrorMethod: e.formErrorMethod,
          error: e.error,
          errorStackTrace: e.stackTrace,
        );
      } else if (e is FormPropTypeMismatchError) {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: null,
          formErrorMethod: FormErrorMethod.unknown,
          error: e.toAppError(
            formModelName: getClassNameWithoutGenerics(this),
          ),
          errorStackTrace: stackTrace,
        );
      } else {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: null,
          formErrorMethod: FormErrorMethod.unknown,
          error: e,
          errorStackTrace: stackTrace,
        );
      }
      _formModelStructure._setFormError(formErrorInfo);

      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: formErrorInfo.methodName,
        error: formErrorInfo.error,
        stackTrace: formErrorInfo.errorStackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      final FormDataState formDataState = switch (activityType) {
        FormActivityType.startCreatingOrEditing =>
            FormDataStateFatalError(errorInfo: errorInfo),
        FormActivityType.updateFromFormView =>
            FormDataStateLoadedFresh(transientErrorInfo: errorInfo),
        FormActivityType.patchFormFields =>
            FormDataStateLoadedFresh(transientErrorInfo: errorInfo)
      };

      __endFormActivityWithDataState(
        formDataState: formDataState,
        activityType: activityType,
        error: e,
      );
      return false;
    }

    return __endFormActivityWithDataState(
      formDataState: FormDataStateLoadedFresh(),
      activityType: activityType,
      error: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __throwErrorIfNotASimplePropName({
    required String propName,
    required FormErrorMethod formErrorMethod,
  }) {
    if (_formModelStructure._isMultiOptFormProp(propName)) {
      throw DevError(
        errorMessage:
        '$propName is not a ${getTypeNameWithoutGenerics(SimpleFormPropModel)}',
        errorDetails: [
          "See ${getClassNameWithoutGenerics(
              this)}.${getClassNameWithoutGenerics(formErrorMethod)}() method."
        ],
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __endFormActivityWithDataState({
    required FormDataState formDataState,
    required FormActivityType activityType,
    required dynamic error,
  }) {
    try {
      _formModelStructure._updateTempToReal();

      if (activityType == FormActivityType.startCreatingOrEditing) {
        _formModelStructure._setInitialFormDataForItemFirstLoad();
      }

      _formKeyPatchValue(
        newCurrentValue: _formModelStructure._currentFormData,
      );

      _formModelStructure._setFormDataState(
        formDataState: formDataState,
        error: error,
      );

      if (activityType == FormActivityType.startCreatingOrEditing) {
        if (formDataState.isLoaded) {
          _formModelStructure._formInitialDataReady = true;
        }
      }

      return true;
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "__endFormActivityWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      _formKeyPatchValue(
        newCurrentValue: _formModelStructure._currentFormData,
      );
      final formDataState = switch (activityType) {
        FormActivityType.startCreatingOrEditing =>
            FormDataStateFatalError(errorInfo: errorInfo),
        FormActivityType.updateFromFormView =>
            FormDataStateLoadedFresh(transientErrorInfo: errorInfo),
        FormActivityType.patchFormFields =>
            FormDataStateLoadedFresh(transientErrorInfo: errorInfo),
      };

      _formModelStructure._setFormDataState(
        formDataState: formDataState,
        error: e,
      );
      return false;
    } finally {
      _formModelStructure.__isTempMode = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    try {
      final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;
      for (FormBuilderState formState in activeForms) {
        formState.patchValue(newCurrentValue);
      }
    } finally {}
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<ADDITIONAL_FORM_RELATED_DATA?> _performLoadAdditionalFormRelatedData(
      ExecutionTrace executionTrace,) async {
    try {
      final INIT_DATA? initData = task.initData;

      executionTrace.addControllableCall(
        codeId: "#99000",
        caller: this,
        methodName: "performLoadAdditionalFormRelatedData",
        suffixShortDesc: "",
        parameters: {
          "initData": initData,
        },
      );
      return await performLoadAdditionalFormRelatedData(
        initData: initData,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "performLoadAdditionalFormRelatedData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      final fatalErrorInfo = FormDataStateFatalError(errorInfo: errorInfo);
      _formModelStructure._setFormDataState(
        formDataState: fatalErrorInfo,
        error: e,
      );
      return null;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptPropDataCascade({
    required final ExecutionTrace executionTrace,
    required final CREATION_PRESET? creationPreset,
    required final FormActivityType activityType,
    required final ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required final FORM_INPUT? formInput,
    required final Object? parentMultiOptPropValue,
    required final MultiOptFormPropModel multiOptProp,
    required final bool parentValueIsInitialValue,
    required final Map<String, dynamic> formKeyInstantValues,
  }) async {
    final String multiOptPropName = multiOptProp.propName;
    final SelectionType selectionType = multiOptProp.selectionType;

    executionTrace.addInfo(
      codeId: "#97500",
      shortDesc:
      "Loading Data for ${debugObjHtml(multiOptProp)} and its children..",
    );

    XData? tempMultiOptPropXData =
    _formModelStructure._getTempMultiOptPropXData(
      propName: multiOptPropName,
    );

    final dynamic tempInitialMultiOptValue = _formModelStructure
        ._getTempInitialPropValue(propName: multiOptPropName);
    final dynamic tempCurrentMultiOptValue = _formModelStructure
        ._getTempCurrentPropValue(propName: multiOptPropName);

    dynamic newSelectedValue = _formModelStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );
    if (activityType == FormActivityType.updateFromFormView) {
      if (formKeyInstantValues.containsKey(multiOptPropName)) {
        newSelectedValue = formKeyInstantValues[multiOptPropName];
      }
    }

    final bool valueChanged;
    if (tempMultiOptPropXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempMultiOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }

    final bool multiOptValueIsInitialValue;
    if (tempMultiOptPropXData == null) {
      multiOptValueIsInitialValue = false;
    } else {
      multiOptValueIsInitialValue = tempMultiOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempInitialMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }

    multiOptProp._tempCurrentValue = newSelectedValue;

    if (valueChanged) {
      _formModelStructure._updateChildrenMultiOptValueToNullCascade(
        multiOptProp: multiOptProp,
      );
    }

    if (tempMultiOptPropXData == null) {
      _formModelStructure._setTempMultiOptPropXData(
        multiOptPropName: multiOptPropName,
        multiOptPropXData: null,
      );
      _formModelStructure._updatePropsTempValues({
        multiOptPropName: null,
      });
    }

    bool forceReload = activityType != FormActivityType.updateFromFormView &&
        multiOptProp.parent == null &&
        multiOptProp._markToReload;

    if (tempMultiOptPropXData == null || forceReload) {
      multiOptProp._loadCount++;
      try {
        executionTrace.addControllableCall(
          codeId: "#97540",
          caller: this,
          methodName: "performLoadMultiOptPropXData",
          suffixShortDesc: "",
          parameters: {
            "multiOptPropName": multiOptPropName,
            "parentMultiOptPropValue": parentMultiOptPropValue,
            "selectionType": selectionType,
            "initData": task.initData,
            "formInput": formInput,
            "additionalFormRelatedData": additionalFormRelatedData,
          },
        );
        tempMultiOptPropXData = await performLoadMultiOptPropXData(
          formInput: formInput,
          initData: task.initData,
          additionalFormRelatedData: additionalFormRelatedData,
          parentMultiOptPropValue: parentMultiOptPropValue,
          multiOptPropName: multiOptPropName,
          selectionType: selectionType,
        );
      } catch (e, stackTrace) {
        throw FormMethodError(
          propName: multiOptPropName,
          formErrorMethod: FormErrorMethod.performLoadMultiOptPropXData,
          error: e,
          stackTrace: stackTrace,
        );
      }

      multiOptProp._markToReload = false;
      multiOptProp._tempCurrentXData = tempMultiOptPropXData;
    }

    List? currentSelectedItems;
    List? candidateSelectedItems;
    OptValueWrap? initialValueWrap;
    final INIT_DATA? initData = task.initData;

    if (tempMultiOptPropXData != null) {
      if (activityType == FormActivityType.startCreatingOrEditing) {
        if (initData == null) {
          if (!_defaultMultiOptValuesInitiated) {
            initialValueWrap = __specifyCreationValueForMultiOptProp(
              executionTrace: executionTrace,
              creationPreset: creationPreset,
              additionalFormRelatedData: additionalFormRelatedData,
              multiOptPropName: multiOptPropName,
              selectionType: selectionType,
              multiOptPropXData: tempMultiOptPropXData,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
          }

          if (formInput != null && formInput is! EmptyFormInput) {
            initialValueWrap = __extractUpdateValueForMultiOptProp(
              executionTrace: executionTrace,
              formInput: formInput,
              multiOptPropXData: tempMultiOptPropXData,
              multiOptPropName: multiOptPropName,
              selectionType: selectionType,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
          }
        } else {
          initialValueWrap = __extractMultiOptPropValueFromInitData(
            executionTrace: executionTrace,
            additionalFormRelatedData: additionalFormRelatedData,
            initData: initData,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            selectionType: selectionType,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
        }
      } else if (activityType == FormActivityType.patchFormFields) {
        if (formInput != null && formInput is! EmptyFormInput) {
          initialValueWrap = __extractUpdateValueForMultiOptProp(
            executionTrace: executionTrace,
            formInput: formInput,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            selectionType: selectionType,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
        }
      }

      final dynamic tempCurrentValue =
      _formModelStructure._getTempCurrentPropValue(
        propName: multiOptPropName,
      );

      if (tempCurrentValue != null) {
        if (tempCurrentValue is List) {
          currentSelectedItems =
          tempCurrentValue.isEmpty ? null : tempCurrentValue;
        } else {
          currentSelectedItems = [tempCurrentValue];
        }
      }
      if (currentSelectedItems != null) {
        currentSelectedItems = tempMultiOptPropXData._resolveItemsFromRawData(
          dynamicValues: currentSelectedItems,
          addOrphan: true,
          clearOrphanItems: true,
        );
      }

      candidateSelectedItems = initialValueWrap?.values;
      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    } else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }

    _formModelStructure._setTempMultiOptPropXData(
      multiOptPropName: multiOptPropName,
      multiOptPropXData: tempMultiOptPropXData,
    );

    final dynamic initialValue;
    if (activityType == FormActivityType.startCreatingOrEditing) {
      initialValue = initialValueWrap?.values;
    } else {
      initialValue = _formModelStructure._getInitialPropValue(
        propName: multiOptPropName,
      );
    }

    if (activityType == FormActivityType.startCreatingOrEditing ||
        parentValueIsInitialValue) {
      tempMultiOptPropXData?._addInitialValueIfOrphan(
        initialValue: initialValue,
        removeCurrentOrphanItems: true,
      );
    }

    candidateSelectedItems = tempMultiOptPropXData?._resolveItemsFromRawData(
      dynamicValues: candidateSelectedItems,
      addOrphan: true,
      clearOrphanItems: false,
    ) ??
        [];

    if (candidateSelectedItems.isNotEmpty) {
      if (multiOptProp.selectionType == SelectionType.single) {
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _formModelStructure._updatePropsTempValues({
          multiOptPropName: candidateSelectedItem,
        });
      } else {
        _formModelStructure._updatePropsTempValues({
          multiOptPropName: candidateSelectedItems,
        });
      }
    } else {
      _formModelStructure._updatePropsTempValues({
        multiOptPropName: null,
      });
    }

    Object? tempSelectedPropValue =
    _formModelStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );

    if (tempSelectedPropValue != null) {
      for (MultiOptFormPropModel child in multiOptProp._children) {
        await _loadMultiOptPropDataCascade(
          executionTrace: executionTrace,
          creationPreset: creationPreset,
          additionalFormRelatedData: additionalFormRelatedData,
          formInput: formInput,
          parentMultiOptPropValue: tempSelectedPropValue,
          parentValueIsInitialValue: multiOptValueIsInitialValue,
          multiOptProp: child,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void patchPropValue(String propertyName, dynamic value) {
    _formModelStructure._setCurrentPropValue(
      propName: propertyName,
      value: value,
    );
    final activeForms = ui._visibleFormBuilderStates;
    for (var formState in activeForms) {
      formState.patchValue({propertyName: value});
    }

    ui.refreshAllViews(force: true);
  }

  dynamic getPropValue(String propName) {
    return _formModelStructure._getCurrentPropValue(
      propName: propName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? getMultiOptPropXData(String multiOptPropName) {
    return _formModelStructure._getCurrentMultiOptPropXData(
      propName: multiOptPropName,
    );
  }

  dynamic getMultiOptPropData(String multiOptPropName) {
    return _formModelStructure._getCurrentMultiOptPropData(
      propName: multiOptPropName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __specifyCreationValueForMultiOptProp({
    required ExecutionTrace executionTrace,
    required CREATION_PRESET? creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      executionTrace.addControllableCall(
        codeId: "#98300",
        caller: this,
        methodName: "specifyCreationValueForMultiOptProp",
        suffixShortDesc: "",
        parameters: {
          "multiOptPropXData": multiOptPropXData,
          "multiOptPropName": multiOptPropName,
          "selectionType": selectionType,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "creationPreset": creationPreset,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      OptValueWrap? valueWrap = specifyCreationValueForMultiOptProp(
        multiOptPropXData: multiOptPropXData,
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        parentMultiOptPropValue: parentMultiOptPropValue,
        creationPreset: creationPreset,
        additionalFormRelatedData: additionalFormRelatedData,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "specifyCreationValueForMultiOptProp",
          multiOptPropName: multiOptPropName,
        );
        return null;
      }
      List? value = valueWrap.values;
      return OptValueWrap.multi(
        multiOptPropXData._resolveItemsFromRawData(
          dynamicValues: value,
          addOrphan: true,
          clearOrphanItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw FormMethodError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.specifyDefaultValueForMultiOptProp,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createNullValueWrapAppError({
    required String methodName,
    required String multiOptPropName,
  }) {
    MultiOptFormPropModel? multiOptProp =
    _formModelStructure._getMultiOptFormProp(multiOptPropName);
    if (multiOptProp == null) {
      throw "The '$multiOptPropName' is not $MultiOptFormPropModel";
    }
    String message =
        "The ${getClassName(
        this)}.$methodName() method must return a non-null $OptValueWrap for the multiOptPropName '$multiOptPropName'. ";
    if (multiOptProp.selectionType == SelectionType.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
      "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
    "And return null for not $MultiOptFormPropModel. See the specification of this method for more information.";
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractMultiOptPropValueFromInitData({
    required ExecutionTrace executionTrace,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required INIT_DATA initData,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      executionTrace.addControllableCall(
        codeId: "#98200",
        caller: this,
        methodName: "extractMultiOptPropValueFromInitData",
        suffixShortDesc: "",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "selectionType": selectionType,
          "multiOptPropXData": multiOptPropXData,
          "initData": initData,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      OptValueWrap? valueWrap = extractMultiOptPropValueFromInitData(
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        multiOptPropXData: multiOptPropXData,
        initData: initData,
        parentMultiOptPropValue: parentMultiOptPropValue,
        additionalFormRelatedData: additionalFormRelatedData,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractMultiOptPropValueFromInitData",
          multiOptPropName: multiOptPropName,
        );
      }
      return valueWrap;
    } catch (e, stackTrace) {
      throw FormMethodError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.extractMultiOptPropValueFromItemDetail,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractUpdateValueForMultiOptProp({
    required ExecutionTrace executionTrace,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required FORM_INPUT formInput,
    required Object? parentMultiOptPropValue,
  }) {
    if (formInput is EmptyFormInput) {
      return null;
    }
    try {
      executionTrace.addControllableCall(
        codeId: "#98400",
        caller: this,
        methodName: "extractUpdateValueForMultiOptProp",
        suffixShortDesc: "",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "multiOptPropXData": multiOptPropXData,
          "selectionType": selectionType,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "formInput": formInput,
        },
      );
      OptValueWrap? valueWrap = extractUpdateValueForMultiOptProp(
        multiOptPropName: multiOptPropName,
        multiOptPropXData: multiOptPropXData,
        selectionType: selectionType,
        parentMultiOptPropValue: parentMultiOptPropValue,
        formInput: formInput,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractUpdateValueForMultiOptProp",
          multiOptPropName: multiOptPropName,
        );
      }
      List? value = valueWrap?.values ?? [];
      return OptValueWrap.multi(
        multiOptPropXData._resolveItemsFromRawData(
          dynamicValues: value,
          addOrphan: true,
          clearOrphanItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw FormMethodError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.extractUpdateValueForMultiOptProp,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isNew => _formModelStructure.isNew;

  Map<String, dynamic> get initialFormData =>
      _formModelStructure._initialFormData;

  Map<String, dynamic> get currentFormData =>
      _formModelStructure._currentFormData;

  // ***************************************************************************
  // ***************************************************************************

  void _clearDataWithDataState({required FormDataState formDataState}) {
    try {
      __disableAutovalidation();
      _formModelStructure._clearFormDataWithState(
        formDataState: formDataState,
      );
      __clearFormKey();
      task.ui.refreshControlBars();
    } catch (e, stackTrace) {
      _handleError(
        shelf: null,
        methodName: "_clearDataWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearFormKey() {
    final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;
    for (FormBuilderState formState in activeForms) {
      final Map<String, dynamic> instantValues = formState.instantValue;
      final Map<String, dynamic> newFormData = {...instantValues}
        ..updateAll((k, v) => null);
      formState.patchValue(newFormData);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool isEnabled() {
    return !task.isLoadingInitData && !task.isExecuting;
  }

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
    return isEnabled() && isDirty();
  }

  @override
  void _refreshAllViews() {
    activity.ui.refreshAllViews();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation("Called when user makes a change in FormView.")
  @_FormViewChangeAnnotation()
  @override
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {
    final XActivity xActivity = _XActivityFormViewChange(formModel: this);

    XTask xTask = xActivity.findXTaskByName(task.name)!;
    XTaskFormModel xTaskFormModel = xTask.xTaskFormModel!;

    xTaskFormModel._createAndSetFormModelExecutionIntentViewChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue(showOverlay: false);
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable<FormModelPatchFormFieldsPrecheck> __canPatchFormFields({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.busy,
      );
    }
    if (formMode == FormMode.none) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.formInNoneMode,
      );
    }
    if (dataState.isPending) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.formInPendingState,
      );
    }
    if (dataState.isFatalError) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.formInFatalErrorState,
      );
    }
    return Actionable<FormModelPatchFormFieldsPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_FormModelPatchFormFieldsAnnotation()
  Future<FormModelPatchFormFieldsResult> patchFormFields({
    required FORM_INPUT formInput,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "patchFormFields",
      parameters: {
        "formInput": formInput,
      },
      isLibMethod: true,
    );

    final bool checkBusyTrue = true;

    executionTrace.addInfo(
      codeId: "#98500",
      shortDesc:
      "Calling ${debugObjHtml(
          this)}.__canPatchFormFields() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );

    final Actionable<FormModelPatchFormFieldsPrecheck> actionable =
    __canPatchFormFields(
      checkBusy: checkBusyTrue,
    );
    if (!actionable.yes) {
      executionTrace.addInfo(
        codeId: "#98540",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );
      _addErrorLogActionable(
        shelf: null,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormModelPatchFormFieldsResult(
        precheck: actionable.errCode,
      );
    }

    final XActivity xActivity =
    _XActivityTaskFormModelPatchFormFields(formModel: this);

    XTask xTask = xActivity.findXTaskByName(task.name)!;
    XTaskFormModel xTaskFormModel = xTask.xTaskFormModel!;

    executionTrace.addExecutionIntent(
      codeId: "#98580",
      owner: this,
      executionIntentType: FormModelPatchFormFieldsIntent,
      suffixShortDesc: "",
    );
    final executionIntent = xTaskFormModel
        ._createAndSetFormModelExecutionIntentPatchFormFields<FORM_INPUT>(
        formInput: formInput);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFormModelInspector() async {
    // BuildContext context = FlutterArtistCore.context;
    //
    // await DebugFormModelInspectorDialog.show(
    //   context: context,
    //   locationInfo: getClassName(this),
    //   formModel: this,
    // );
    throw UnimplementedError("TODO: showDebugFormModelInspector");
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFormPropModel? findMultiOptFormProp({
    required String multiOptPropName,
  }) {
    return _formModelStructure._findMultiOptFormProp(
      multiOptPropName,
    );
  }

  int debugGetMultiOptPropLoadCount(String multiOptPropName) {
    return _formModelStructure._debugGetMultiOptPropLoadCount(
      multiOptPropName: multiOptPropName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXTaskFormModel(XTaskFormModel thisXTaskFormModel) {
    if (!identical(thisXTaskFormModel.formModel, this)) {
      String message =
          "Error Assert form model: ${thisXTaskFormModel.formModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
