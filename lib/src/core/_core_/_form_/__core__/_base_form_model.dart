part of '../../core.dart';

abstract class BaseFormModel<
        CREATION_PRESET extends CreationPreset,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends _Core {
  final FormModelConfig config;

  late final FormModelStructure _formModelStructure;

  bool _changeEventLocked = false;

  FormMode get formMode;

  String get pathInfo;

  FormModelStructure get formModelStructure => _formModelStructure;

  FormDataState get dataState => _formModelStructure._formDataState;

  FormErrorInfo? get formErrorInfo => _formModelStructure.formErrorInfo;

  bool get formInitialDataReady => _formModelStructure._formInitialDataReady;

  InternalFormMode get _internalFormMode =>
      _formModelStructure._internalFormMode;

  bool _defaultSimpleValuesInitiated = false;
  bool _defaultMultiOptValuesInitiated = false;

  bool get defaultSimpleValuesInitiated => _defaultSimpleValuesInitiated;

  bool get defaultMultiOptValuesInitiated => _defaultMultiOptValuesInitiated;

  ADDITIONAL_FORM_RELATED_DATA? _additionalFormRelatedData;
  FORM_INPUT? _creationFormInput;

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  AutovalidateMode get autovalidateMode => _autovalidateMode;

  AutovalidateMode get _autovalidateModeForFormView {
    if (_formModelStructure._internalFormMode == InternalFormMode.none) {
      return AutovalidateMode.disabled;
    }
    return _autovalidateMode;
  }

  bool get isNew => _formModelStructure.isNew;

  Map<String, dynamic> get initialFormData =>
      _formModelStructure._initialFormData;

  Map<String, dynamic> get currentFormData =>
      _formModelStructure._currentFormData;

  bool get effectivePreventUnsavedChangesLoss => true;

  late final debug = _FormModelDebugInfo();

  late final ui = _FormUiComponents(formModel: this);

  BaseFormModel({
    FormModelConfig config = const FormModelConfig(),
  })  : config = config.copy(),
        _autovalidateMode = config.autovalidateMode {
    __defineFormModelStructure();
  }

  // ===========================================================================

  Type getFormInputType() => FORM_INPUT;
  Type getAdditionalFormRelatedDataType() => ADDITIONAL_FORM_RELATED_DATA;

  // ===========================================================================

  String debugClassParametersDefinition();

  // ===========================================================================
  // DOMAIN CONTRACTS (To be implemented by BlockFormModel & TaskFormModel)
  // ===========================================================================

  /// Returns the underlying domain data instance: [ITEM_DETAIL] for Block, [INIT_DATA] for Task.
  Object? get rawDomainData;

  /// Returns the Shelf context if available (Block), otherwise null (Task).
  Shelf? get relatedShelf;

  /// Resolves the initial selection wrapper for a multi-option property during Creation mode.
  @_AbstractMethodAnnotation()
  OptValueWrap? _internalSpecifyCreationValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  /// Supplies baseline initial values for simple form properties during Creation mode.
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? _internalSpecifyCreationValuesForSimpleProps({
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  /// Loads dynamic option dataset ([XData]) for a multi-option form property.
  Future<XData?> _internalPerformLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required Object? rawDomainData,
  });

  /// Polymorphic bridge to extract simple properties from persisted/loaded domain data.
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? _internalExtractSimplePropValuesFromDomainData({
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object rawDomainData,
  });

  /// Polymorphic bridge to extract multi-opt selection from persisted/loaded domain data.
  @_AbstractMethodAnnotation()
  OptValueWrap? _internalExtractMultiOptPropValueFromDomainData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object rawDomainData,
  });

  /// Asynchronously fetches auxiliary metadata specifically required for form display.
  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA>
      _internalPerformLoadAdditionalFormRelatedData({
    required Object? rawDomainData,
  });

  // ===========================================================================
  // INITIALIZATION & STRUCTURE DEFINITION
  // ===========================================================================

  void __defineFormModelStructure() {
    try {
      _formModelStructure = defineFormModelStructure();
      _formModelStructure.formModel = this;
    } on FormPropInvalidNameError catch (e) {
      String message = "Invalid Form propName '${e.propName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFormModelStructure()' method for details.";
      throw _createFatalAppError(message);
    } on FormPropDuplicateNameError catch (e) {
      String message = "Duplicate Form propName '${e.propName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFormModelStructure()' method for details.";
      throw _createFatalAppError(message);
    } catch (e, stackTrace) {
      print(stackTrace);
      String message = "Unknown Error $e in ${getClassName(this)}";
      throw _createFatalAppError(message);
    }
  }

  Type getFormRelatedDataType() => ADDITIONAL_FORM_RELATED_DATA;

  Type getCreationPresetType() => CREATION_PRESET;

  bool isDirty() => _formModelStructure._isDirty();

  void resetForm() {
    bool canReset = _canResetForm();
    if (!canReset) return;
    try {
      _changeEventLocked = true;
      _formModelStructure._resetFormData();
      Map<String, dynamic> initData = {..._formModelStructure._initialFormData};
      final activeForms = ui._visibleFormBuilderStates;

      for (FormBuilderState formState in activeForms) {
        Map<String, dynamic> localInitData = {...initData};
        for (String key in formState.instantValue.keys) {
          if (!localInitData.containsKey(key)) {
            localInitData[key] = null;
          }
        }
        formState.patchValue(localInitData);
      }
      _refreshAllViews();
    } finally {
      _changeEventLocked = false;
    }
  }

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
    return _formModelStructure._getCurrentPropValue(propName: propName);
  }

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

  MultiOptFormPropModel? findMultiOptFormProp(
      {required String multiOptPropName}) {
    return _formModelStructure._findMultiOptFormProp(multiOptPropName);
  }

  int debugGetMultiOptPropLoadCount(String multiOptPropName) {
    return _formModelStructure._debugGetMultiOptPropLoadCount(
      multiOptPropName: multiOptPropName,
    );
  }

  Actionable<FormModelPatchFormFieldsPrecheck> __canPatchFormFields({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.busy,
      );
    }
    if (_internalFormMode == InternalFormMode.none) {
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

  bool __checkBeforePatchFormFields({
    required bool checkBusy,
    required bool addErrorLog,
    required bool showErrSnackBar,
  }) {
    Actionable createActionable = __canPatchFormFields(checkBusy: checkBusy);
    if (!createActionable.yes) {
      if (addErrorLog) {
        _addErrorLogActionable(
          shelf: relatedShelf,
          actionableFalse: createActionable,
          showErrSnackBar: showErrSnackBar,
          tipDocument: null,
        );
      }
      return false;
    }
    return true;
  }

  // ===========================================================================
  // UNIFIED LIFECYCLE: START NEW FORM ACTIVITY
  // ===========================================================================

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
      codeId: "#06000",
      shortDesc: "${debugObjHtml(this)} on _startNewFormActivity().",
    );

    if (activityType == FormActivityType.startCreatingOrEditing) {
      debug._loadCount++;
      _autovalidateMode = config.autovalidateMode;
    } else {
      _autovalidateMode = config.autovalidateMode;
    }

    final Object? domainData = rawDomainData;
    final InternalFormMode currentFormMode;
    ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData;

    switch (activityType) {
      case FormActivityType.startCreatingOrEditing:
        currentFormMode = domainData == null
            ? InternalFormMode.creation
            : InternalFormMode.edit;

        _formModelStructure._clearFormError();
        _formModelStructure._setFormDataState(
          formDataState: FormDataStatePending(),
          error: null,
        );

        if (currentFormMode == InternalFormMode.creation) {
          _creationFormInput = formInput;
        } else {
          _creationFormInput = null;
        }

        additionalFormRelatedData =
            await _performLoadAdditionalFormRelatedData(executionTrace);
        if (additionalFormRelatedData == null) {
          return false;
        }
        _additionalFormRelatedData = additionalFormRelatedData;
        break;

      case FormActivityType.updateFromFormView:
        currentFormMode = _internalFormMode;
        if (formInput != null) {
          throw DevError(
            errorMessage:
                "Dev Error. formInput must be null if FormModel.activityType = updateFromFormView.",
          );
        }
        if (currentFormMode == InternalFormMode.creation) {
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
        currentFormMode = _internalFormMode;
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

    _formModelStructure._setInternalFormMode(currentFormMode);
    final bool isNoneMode = currentFormMode == InternalFormMode.none;
    final bool isCreationMode = currentFormMode == InternalFormMode.creation;

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
      // CASE 1: EDIT / DATA PRESENT MODE (domainData != null)
      // -----------------------------------------------------------------------
      if (domainData != null) {
        executionTrace.addInfo(
          codeId: "#06180",
          shortDesc: "Populating form from domain data."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @domainData: ${debugObjHtml(domainData)}.",
        );
        try {
          executionTrace.addControllableCall(
            codeId: "#06200",
            caller: this,
            methodName: "extractSimplePropValuesFromDomainData",
            suffixShortDesc: "",
            parameters: {
              "additionalFormRelatedData": additionalFormRelatedData,
              "domainData": domainData,
            },
          );
          final simplePropValueMap =
              _internalExtractSimplePropValuesFromDomainData(
                    additionalFormRelatedData: additionalFormRelatedData,
                    rawDomainData: domainData,
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
            shelf: relatedShelf,
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
            codeId: "#06400",
            shortDesc:
                "The ${debugObjHtml(this)}.extractSimplePropValuesFromDomainData() method encountered an error!",
            errorInfo: errorInfo,
          );
          return false;
        }
      }
      // -----------------------------------------------------------------------
      // CASE 2: CREATION / DEFAULT MODE (domainData == null)
      // -----------------------------------------------------------------------
      else {
        executionTrace.addInfo(
          codeId: "#06500",
          shortDesc: "Initial creation defaults in form."
              "\n - @activityType: <b>$activityType</b>.",
        );

        if (!_defaultSimpleValuesInitiated) {
          try {
            executionTrace.addControllableCall(
              codeId: "#06540",
              caller: this,
              methodName: "specifyCreationValuesForSimpleProps",
              suffixShortDesc: "",
              parameters: {
                "creationPreset": creationPreset,
                "additionalFormRelatedData": additionalFormRelatedData,
              },
            );

            final Map<String, dynamic> simplePropValueDefault =
                _internalSpecifyCreationValuesForSimpleProps(
                      creationPreset: creationPreset!,
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
              shelf: relatedShelf,
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
              codeId: "#06620",
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
              shelf: relatedShelf,
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
            codeId: "#06720",
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
            shelf: relatedShelf,
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
        shelf: relatedShelf,
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

  // ===========================================================================
  // UNIFIED MULTI-OPT PROP DATA LOADING (CASCADE)
  // ===========================================================================

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
      codeId: "#17000",
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
          codeId: "#17400",
          caller: this,
          methodName: "performLoadMultiOptPropXData",
          suffixShortDesc: "",
          parameters: {
            "multiOptPropName": multiOptPropName,
            "parentMultiOptPropValue": parentMultiOptPropValue,
            "selectionType": selectionType,
            "rawDomainData": rawDomainData,
            "formInput": formInput,
            "additionalFormRelatedData": additionalFormRelatedData,
          },
        );
        tempMultiOptPropXData = await _internalPerformLoadMultiOptPropXData(
          formInput: formInput,
          rawDomainData: rawDomainData,
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
    final Object? domainData = rawDomainData;

    if (tempMultiOptPropXData != null) {
      if (activityType == FormActivityType.startCreatingOrEditing) {
        if (domainData == null) {
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
          initialValueWrap = __extractMultiOptPropValueFromDomainData(
            executionTrace: executionTrace,
            additionalFormRelatedData: additionalFormRelatedData,
            rawDomainData: domainData,
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

  // ===========================================================================
  // AUXILIARY LOAD & STATE CLEAR
  // ===========================================================================

  Future<ADDITIONAL_FORM_RELATED_DATA?> _performLoadAdditionalFormRelatedData(
    ExecutionTrace executionTrace,
  ) async {
    try {
      executionTrace.addControllableCall(
        codeId: "#91000",
        caller: this,
        methodName: "performLoadAdditionalFormRelatedData",
        suffixShortDesc: "",
        parameters: {
          "rawDomainData": rawDomainData,
        },
      );
      return await _internalPerformLoadAdditionalFormRelatedData(
        rawDomainData: rawDomainData,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: relatedShelf,
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

  void _clearDataWithDataState({required FormDataState formDataState}) {
    try {
      __disableAutovalidation();
      _formModelStructure._clearFormDataWithState(
        formDataState: formDataState,
      );
      __clearFormKey();
      _refreshControlBars();
    } catch (e, stackTrace) {
      _handleError(
        shelf: relatedShelf,
        methodName: "_clearDataWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  // ===========================================================================
  // HELPERS & VALIDATION
  // ===========================================================================

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
        codeId: "#33000",
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
      OptValueWrap? valueWrap = _internalSpecifyCreationValueForMultiOptProp(
        multiOptPropXData: multiOptPropXData,
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        parentMultiOptPropValue: parentMultiOptPropValue,
        creationPreset: creationPreset!,
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

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractMultiOptPropValueFromDomainData({
    required ExecutionTrace executionTrace,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object rawDomainData,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      executionTrace.addControllableCall(
        codeId: "#32000",
        caller: this,
        methodName: "extractMultiOptPropValueFromDomainData",
        suffixShortDesc: "",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "selectionType": selectionType,
          "multiOptPropXData": multiOptPropXData,
          "rawDomainData": rawDomainData,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      OptValueWrap? valueWrap = _internalExtractMultiOptPropValueFromDomainData(
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        multiOptPropXData: multiOptPropXData,
        rawDomainData: rawDomainData,
        parentMultiOptPropValue: parentMultiOptPropValue,
        additionalFormRelatedData: additionalFormRelatedData,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractMultiOptPropValueFromDomainData",
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

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractUpdateValueForMultiOptProp({
    required ExecutionTrace executionTrace,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required FORM_INPUT formInput,
    required Object? parentMultiOptPropValue,
  }) {
    if (formInput is EmptyFormInput) return null;
    try {
      executionTrace.addControllableCall(
        codeId: "#18000",
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
      _formKeyPatchValue(newCurrentValue: _formModelStructure._currentFormData);
      _formModelStructure._setFormDataState(
          formDataState: formDataState, error: error);

      if (activityType == FormActivityType.startCreatingOrEditing &&
          formDataState.isLoaded) {
        _formModelStructure._formInitialDataReady = true;
      }

      if (_formModelStructure._formInitialDataReady &&
          activityType == FormActivityType.startCreatingOrEditing &&
          _internalFormMode == InternalFormMode.edit) {
        final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;
        for (FormBuilderState formState in activeForms) {
          formState.validate(focusOnInvalid: false);
        }
      }
      return true;
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: relatedShelf,
        methodName: "__endFormActivityWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      _formKeyPatchValue(newCurrentValue: _formModelStructure._currentFormData);
      final fallbackState = switch (activityType) {
        FormActivityType.startCreatingOrEditing =>
          FormDataStateFatalError(errorInfo: errorInfo),
        FormActivityType.updateFromFormView =>
          FormDataStateLoadedFresh(transientErrorInfo: errorInfo),
        FormActivityType.patchFormFields =>
          FormDataStateLoadedFresh(transientErrorInfo: errorInfo),
      };

      _formModelStructure._setFormDataState(
          formDataState: fallbackState, error: e);
      return false;
    } finally {
      _formModelStructure.__isTempMode = false;
    }
  }

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
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the multiOptPropName '$multiOptPropName'. ";
    if (multiOptProp.selectionType == SelectionType.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptFormPropModel. See the specification of this method for more information.";
  }

  void __throwErrorIfNotASimplePropName({
    required String propName,
    required FormErrorMethod formErrorMethod,
  }) {
    if (_formModelStructure._isMultiOptFormProp(propName)) {
      throw DevError(
        errorMessage:
            '$propName is not a ${getTypeNameWithoutGenerics(SimpleFormPropModel)}',
        errorDetails: [
          "See ${getClassNameWithoutGenerics(this)}.${getClassNameWithoutGenerics(formErrorMethod)}() method."
        ],
      );
    }
  }

  void __clearFormKey() {
    final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;
    for (FormBuilderState formState in activeForms) {
      final Map<String, dynamic> instantValues = formState.instantValue;
      final Map<String, dynamic> newFormData = {...instantValues}
        ..updateAll((k, v) => null);
      formState.patchValue(newFormData);
    }
  }

  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;
    for (FormBuilderState formState in activeForms) {
      formState.patchValue(newCurrentValue);
    }
  }

  void __disableAutovalidation() {
    AutovalidateMode temp = _autovalidateMode;
    _autovalidateMode = AutovalidateMode.disabled;
    ui.refreshAllViews(force: true);
    _autovalidateMode = temp;
  }

  Map<String, dynamic> _getInitialValuesForFormView() =>
      _formModelStructure._currentFormData;

  dynamic getInitialPropValue(String propName) =>
      _formModelStructure._getInitialPropValue(propName: propName);

  Future<void> showFormErrorViewerDialog(BuildContext context) async {
    if (!dataState.isFatalError) return;
    await FormErrorViewerDialog.show(
      context: context,
      formErrorInfo: formErrorInfo!,
      formInitialDataReady: formInitialDataReady,
    );
  }

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
  FormModelStructure defineFormModelStructure();

  bool isEnabled();

  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  });

  bool _canResetForm();

  void _refreshAllViews();

  void _refreshControlBars();

  void _triggerWhenFormViewVisible();

  void _addToRecent();

  void _afterBuildFormView() {
    _formModelStructure._justInitialized = false;
  }
}
