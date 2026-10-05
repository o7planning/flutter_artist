part of '../../core.dart';

/// Base abstract class representing a form model in the FlutterArtist framework,
/// managing form state, structure, validation, and data lifecycle.
abstract class BaseFormModel<
        FORM_INPUT extends FormInput, //
        FORM_OUTPUT extends FormOutput, //
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends _Core {
  /// Configuration options for the form model.
  final FormModelConfig config;

  /// Internal structure defining the form's properties and state.
  late final FormModelStructure _formModelStructure;

  /// Flag to lock change events during batch operations or resets.
  bool _changeEventLocked = false;

  FeatureModule get module;

  FormHost get host;

  /// Returns the current mode of the form (e.g., creation, edit).
  FormMode get formMode;

  /// Returns path information for routing or debugging purposes.
  String get pathInfo;

  /// Exposes the form model structure.
  FormModelStructure get formModelStructure => _formModelStructure;

  /// Returns the current data state of the form (e.g., pending, loaded, error).
  FormDataState get dataState => _formModelStructure._formDataState;

  /// Returns form error information if any error occurred.
  FormErrorInfo? get formErrorInfo => _formModelStructure.formErrorInfo;

  /// Indicates whether the initial form data is fully loaded and ready.
  bool get formInitialDataReady => _formModelStructure._formInitialDataReady;

  /// Internal mode representation for form handling.
  InternalFormMode get _internalFormMode =>
      _formModelStructure._internalFormMode;

  /// Flags tracking whether default simple and multi-option values have been initiated.
  bool _defaultSimpleValuesInitiated = false;
  bool _defaultMultiOptValuesInitiated = false;

  /// Returns whether default simple values have been initiated.
  bool get defaultSimpleValuesInitiated => _defaultSimpleValuesInitiated;

  /// Returns whether default multi-option values have been initiated.
  bool get defaultMultiOptValuesInitiated => _defaultMultiOptValuesInitiated;

  /// Additional data required related to form operations.
  ADDITIONAL_FORM_RELATED_DATA? _additionalFormRelatedData;

  /// Form input used when creating a new record.
  FORM_INPUT? _creationFormInput;

  /// Autovalidate mode for form fields, defaulting to user interaction.
  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  /// Returns the current autovalidate mode.
  AutovalidateMode get autovalidateMode => _autovalidateMode;

  /// Internal getter resolving the autovalidate mode specifically for form views.
  AutovalidateMode get _autovalidateModeForFormView {
    if (_formModelStructure._internalFormMode == InternalFormMode.none) {
      return AutovalidateMode.disabled;
    }
    return _autovalidateMode;
  }

  /// Returns true if the form is in creation or new mode.
  bool get isNew => _formModelStructure.isNew;

  /// Returns the initial form data map.
  Map<String, dynamic> get initialFormData =>
      _formModelStructure._initialFormData;

  /// Returns the current form data map.
  Map<String, dynamic> get currentFormData =>
      _formModelStructure._currentFormData;

  /// Returns whether unsaved changes loss prevention is effectively enabled.
  bool get effectivePreventUnsavedChangesLoss => true;

  /// Debug information helper for the form model.
  late final debug = _FormModelDebugInfo();

  /// UI components helper linked to this form model.
  late final ui = _FormUiComponents(formModel: this);

  /// Constructor initializes configuration and builds the form model structure.
  BaseFormModel({
    FormModelConfig config = const FormModelConfig(),
  })  : config = config.copy(),
        _autovalidateMode = config.autovalidateMode {
    __defineFormModelStructure();
  }

  // ===========================================================================

  /// Returns the runtime type of the form input.
  Type getFormInputType() => FORM_INPUT;

  /// Returns the runtime type of additional form related data.
  Type getAdditionalFormRelatedDataType() => ADDITIONAL_FORM_RELATED_DATA;

  // ===========================================================================

  /// Returns a string definition of class parameters for debugging purposes.
  String debugClassParametersDefinition();

  // ===========================================================================
  // DOMAIN CONTRACTS (To be implemented by subclasses)
  // ===========================================================================

  /// Returns the underlying domain data instance: [ITEM_DETAIL] for Block, [INIT_DATA] for Task/Stage.
  Object? get rawDomainData;

  /// Returns the Shelf context if available (Block), otherwise null (Activity).
  Shelf? get relatedShelf;

  /// Internal hook resolving baseline initial values for simple form properties.
  /// BlockFormModel delegates to edit/creation methods, while ActivityFormModel delegates to initData.
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? _internalResolveInitialSimplePropValues({
    required ExecutionTrace executionTrace,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  /// Internal hook resolving baseline initial selection wrapper for a multi-option property.
  /// BlockFormModel delegates to edit/creation methods, while ActivityFormModel delegates to initData.
  @_AbstractMethodAnnotation()
  OptValueWrap? _internalResolveInitialMultiOptPropValue({
    required ExecutionTrace executionTrace,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
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

  /// Asynchronously fetches auxiliary metadata specifically required for form display.
  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA>
      _internalPerformLoadAdditionalFormRelatedData({
    required Object? rawDomainData,
  });

  // ===========================================================================
  // ===========================================================================

  bool isFormValidated() {
    throw UnimplementedError("TODO: isFormValidated");
  }

  // ===========================================================================
  // INITIALIZATION & STRUCTURE DEFINITION
  // ===========================================================================

  /// Internal method to define and initialize the form model structure safely, handling name conflicts or errors.
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

  /// Returns the type of related form data.
  Type getFormRelatedDataType() => ADDITIONAL_FORM_RELATED_DATA;

  /// Returns whether the form has unsaved modifications (is dirty).
  bool isDirty() => _formModelStructure._isDirty();

  /// Resets the form data back to its initial state if permitted.
  void resetForm() {
    bool canReset = _checkBeforeResetForm();
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

  /// Patches a specific property value in the form and updates active UI views.
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

  /// Retrieves the current value of a specific form property.
  dynamic getPropValue(String propName) {
    return _formModelStructure._getCurrentPropValue(propName: propName);
  }

  /// Retrieves the current XData dataset for a multi-option property.
  XData? getMultiOptPropXData(String multiOptPropName) {
    return _formModelStructure._getCurrentMultiOptPropXData(
      propName: multiOptPropName,
    );
  }

  /// Retrieves the current data value for a multi-option property.
  dynamic getMultiOptPropData(String multiOptPropName) {
    return _formModelStructure._getCurrentMultiOptPropData(
      propName: multiOptPropName,
    );
  }

  /// Finds and returns a multi-option form property model by its name.
  MultiOptFormPropModel? findMultiOptFormProp(
      {required String multiOptPropName}) {
    return _formModelStructure._findMultiOptFormProp(multiOptPropName);
  }

  /// Returns the debug load count for a specific multi-option property.
  int debugGetMultiOptPropLoadCount(String multiOptPropName) {
    return _formModelStructure._debugGetMultiOptPropLoadCount(
      multiOptPropName: multiOptPropName,
    );
  }

  /// Checks whether form fields can be patched based on current system and form state.
  Actionable<FormModelPatchFormFieldsPrecheck> __checkBeforePatchFormFields({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.busy,
      );
    }
    if (dataState.isNone) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.formInNoneState,
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

  // ===========================================================================
  // UNIFIED LIFECYCLE: START NEW FORM ACTIVITY
  // ===========================================================================

  /// Central lifecycle coordinator for Form data mutation, initialization, and validation.
  @_ImportantMethodAnnotation(
      "Called when Form Data is being loaded or user makes changes in FormView")
  Future<bool> _startNewFormActivity({
    required ExecutionTrace executionTrace,
    required FORM_INPUT? formInput,
    required final FormActivityType activityType,
    required Map<String, dynamic>? formKeyInstantValuesInUI,
  }) async {
    debug._formActivityCount++;

    executionTrace.addInfo(
      codeId: "#006000",
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
        if (relatedShelf != null) {
          // BlockFormModel branch: distinguish creation vs edit
          currentFormMode = domainData == null
              ? InternalFormMode.creation
              : InternalFormMode.edit;
        } else {
          // ActivityFormModel (Task/Stage) branch: always compose
          currentFormMode = InternalFormMode.compose;
        }

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
      executionTrace.addInfo(
        codeId: "#006180",
        shortDesc: "Populating simple form properties."
            "\n - @activityType: <b>$activityType</b>."
            "\n - @domainData: ${debugObjHtml(domainData)}.",
      );
      try {
        final Map<String, dynamic> simplePropValueMap =
            _internalResolveInitialSimplePropValues(
                  executionTrace: executionTrace,
                  additionalFormRelatedData: additionalFormRelatedData,
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
          module: relatedShelf,
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
          codeId: "#006400",
          shortDesc:
              "The ${debugObjHtml(this)}._internalResolveInitialSimplePropValues() method encountered an error!",
          errorInfo: errorInfo,
        );
        return false;
      }

      // Apply external FormInput overrides if present
      if (formInput != null) {
        try {
          executionTrace.addControllableCall(
            codeId: "#006620",
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
            formErrorMethod: FormErrorMethod.extractUpdateValuesForSimpleProps,
            error: e,
            errorStackTrace: stackTrace,
          );
          _formModelStructure._setFormError(formErrorInfo);

          final ErrorInfo errorInfo = _handleError(
            module: relatedShelf,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
            tipDocument: null,
          );

          final fatalErrorState = FormDataStateFatalError(errorInfo: errorInfo);
          __endFormActivityWithDataState(
            formDataState: fatalErrorState,
            error: e,
            activityType: activityType,
          );
          return false;
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
            codeId: "#006720",
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
            module: relatedShelf,
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
        module: relatedShelf,
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

  /// Recursively loads multi-option property data down the hierarchical cascade.
  Future<void> _loadMultiOptPropDataCascade({
    required final ExecutionTrace executionTrace,
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
      codeId: "#017000",
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
          codeId: "#017400",
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

    if (tempMultiOptPropXData != null) {
      if (activityType == FormActivityType.startCreatingOrEditing) {
        initialValueWrap = _internalResolveInitialMultiOptPropValue(
          executionTrace: executionTrace,
          multiOptPropName: multiOptPropName,
          selectionType: selectionType,
          multiOptPropXData: tempMultiOptPropXData,
          parentMultiOptPropValue: parentMultiOptPropValue,
          additionalFormRelatedData: additionalFormRelatedData,
        );

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

  /// Loads auxiliary form related data asynchronously.
  Future<ADDITIONAL_FORM_RELATED_DATA?> _performLoadAdditionalFormRelatedData(
    ExecutionTrace executionTrace,
  ) async {
    try {
      executionTrace.addControllableCall(
        codeId: "#091000",
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
        module: relatedShelf,
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

  /// Clears form data associated with a specific data state.
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
        module: relatedShelf,
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

  /// Extracts update values for a multi-option property from form input.
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
        codeId: "#018000",
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

  /// Concludes form activity with a given data state, updating actual values and UI state.
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
        module: relatedShelf,
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

  /// Throws an error when a method returns a null value wrap for a multi-option property.
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

  /// Throws an error if the provided property name does not correspond to a simple property.
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

  /// Clears active form key instant values in UI views.
  void __clearFormKey() {
    final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;
    for (FormBuilderState formState in activeForms) {
      final Map<String, dynamic> instantValues = formState.instantValue;
      final Map<String, dynamic> newFormData = {...instantValues}
        ..updateAll((k, v) => null);
      formState.patchValue(newFormData);
    }
  }

  /// Patches form key values across all visible form builder states.
  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;
    for (FormBuilderState formState in activeForms) {
      formState.patchValue(newCurrentValue);
    }
  }

  /// Temporarily disables autovalidation during structural changes or resets.
  void __disableAutovalidation() {
    AutovalidateMode temp = _autovalidateMode;
    _autovalidateMode = AutovalidateMode.disabled;
    ui.refreshAllViews(force: true);
    _autovalidateMode = temp;
  }

  /// Returns initial values for the form view.
  Map<String, dynamic> _getInitialValuesForFormView() =>
      _formModelStructure._currentFormData;

  /// Retrieves the initial value of a specific property.
  dynamic getInitialPropValue(String propName) =>
      _formModelStructure._getInitialPropValue(propName: propName);

  /// Shows the form error viewer dialog if the data state is in fatal error.
  Future<void> showFormErrorViewerDialog(BuildContext context) async {
    if (!dataState.isFatalError) return;
    await FormErrorViewerDialog.show(
      context: context,
      formErrorInfo: formErrorInfo!,
      formInitialDataReady: formInitialDataReady,
    );
  }

  /// Extracts update values foAbsr simple properties from form input.
  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleProps({
    required FORM_INPUT formInput,
  });

  /// Extracts update value for a multi-option property from form input.
  @_AbstractMethodAnnotation()
  OptValueWrap? extractUpdateValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required FORM_INPUT formInput,
  });

  /// Defines the form model structure containing properties, fields, and options.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// FormModelStructure defineFormModelStructure() {
  ///   return FormModelStructure(
  ///     simplePropDefs: [
  ///       SimpleFormPropDef<int>(propName: "id"),
  ///       SimpleFormPropDef<String>(propName: "name"),
  ///       SimpleFormPropDef<bool>(propName: "active"),
  ///       SimpleFormPropDef<String>(propName: "description"),
  ///     ],
  ///     multiOptPropDefs: [
  ///       MultiOptFormPropDef<ProgramTypeInfo>.singleSelection(
  ///         propName: "programType",
  ///       ),
  ///       // Multi Option Multi Selection Criterion.
  ///       MultiOptFormPropDef<ContributorInfo>.multiSelection(
  ///         propName: "contributors",
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @_AbstractMethodAnnotation()
  FormModelStructure defineFormModelStructure();

  FORM_OUTPUT _getFormOutput() {
    Map<String, dynamic> formMapData = _formModelStructure._currentFormData;
    return convertToFormOutput(formMapData: formMapData);
  }

  /// Converts the raw form map values into a strongly-typed [FORM_OUTPUT] object.
  ///
  /// This method must be implemented by concrete form model subclasses to map
  /// UI input fields into a domain-specific output object.
  ///
  /// If you want a lightweight approach without creating a custom output class,
  /// you can set [FORM_OUTPUT] to [MapBasedFormOutput] and implement it simply as follows:
  /// ```dart
  /// @override
  /// MapBasedFormOutput convertToFormOutput({required Map<String, dynamic> formMapData}) {
  ///   return MapBasedFormOutput(formMapData: formMapData);
  /// }
  /// ```
  @_AbstractMethodAnnotation()
  FORM_OUTPUT convertToFormOutput({
    required Map<String, dynamic> formMapData,
  });

  /// Returns whether the form model is enabled.
  bool isEnabled() {
    return checkFormEnable().yes;
  }

  Actionable<FormEnablePrecheck> checkFormEnable();

  /// Handles changes triggered from the form view interface.
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  });

  /// Determines whether the form can be reset.
  bool _checkBeforeResetForm();

  /// Refreshes all associated views.
  void _refreshAllViews();

  /// Refreshes form control bars.
  void _refreshControlBars();

  /// Triggered when the form view becomes visible.
  void _triggerWhenFormViewVisible();

  /// Lifecycle hook executed after the form view is built.
  void _afterBuildFormView() {
    _formModelStructure._justInitialized = false;
  }
}
