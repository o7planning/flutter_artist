part of '../../core.dart';

/// Base abstract class representing a form model in the FlutterArtist framework,
/// managing form state, structure, validation, and data lifecycle.
abstract class BaseFormModel<
        FORM_PATCH extends FormPatch, //
        FORM_OUTPUT extends FormOutput, //
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends _Core implements MnemonicScope, ClassDefViewable {
  String get name;

  bool get hasError => dataState.isFatalError;

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

  /// Flags tracking whether default plain and managed-option values have been initiated.
  bool _defaultPlainValuesInitiated = false;
  bool _defaultManagedOptValuesInitiated = false;

  /// Returns whether default plain values have been initiated.
  bool get defaultPlainValuesInitiated => _defaultPlainValuesInitiated;

  /// Returns whether default managed-option values have been initiated.
  bool get defaultManagedOptValuesInitiated =>
      _defaultManagedOptValuesInitiated;

  /// Additional data required related to form operations.
  ADDITIONAL_FORM_RELATED_DATA? _additionalFormRelatedData;

  /// Form Patch used when creating a new record.
  FORM_PATCH? _creationFormPatch;

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
  Type getFormPatchType() => FORM_PATCH;

  /// Returns the runtime type of additional form related data.
  Type getAdditionalFormRelatedDataType() => ADDITIONAL_FORM_RELATED_DATA;

  // ===========================================================================
  // DOMAIN CONTRACTS (To be implemented by subclasses)
  // ===========================================================================

  /// Returns the underlying domain data instance: [ITEM_DETAIL] for Block, [INIT_DATA] for Task/Stage.
  Object? get rawDomainData;

  /// Returns the Shelf context if available (Block), otherwise null (Activity).
  FeatureModule get relatedModule;

  /// Internal hook resolving baseline initial values for plain form properties.
  /// BlockFormModel delegates to edit/creation methods, while ActivityFormModel delegates to initData.
  @AbstractMethodAnnotation()
  Map<String, dynamic>? _internalResolveInitialPlainPropValues({
    required ExecutionTrace executionTrace,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  /// Internal hook resolving baseline initial selection wrapper for a managed-option property.
  /// BlockFormModel delegates to edit/creation methods, while ActivityFormModel delegates to initData.
  @AbstractMethodAnnotation()
  OptValueWrap? _internalResolveInitialManagedOptPropValue({
    required ExecutionTrace executionTrace,
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  /// Loads dynamic option dataset ([XData]) for a managed-option form property.
  Future<XData?> _internalPerformLoadManagedOptPropXData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object? rawDomainData,
  });

  /// Asynchronously fetches auxiliary metadata specifically required for form display.
  @AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA>
      _internalPerformLoadAdditionalFormRelatedData({
    required Object? rawDomainData,
  });

  @AbstractMethodAnnotation()
  FocusNavAction? resolveNextFocus({
    required String currentPropName,
    required dynamic currentValue,
    required bool isCurrentFieldValid,
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
      throw AppFatalErrorUtils._createFatalAppError(message);
    } on FormPropDuplicateNameError catch (e) {
      String message = "Duplicate Form propName '${e.propName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFormModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    } catch (e, stackTrace) {
      print(stackTrace);
      String message = "Unknown Error $e in ${getClassName(this)}";
      throw AppFatalErrorUtils._createFatalAppError(message);
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

  /// Retrieves the current XData dataset for a managed-option property.
  XData? getManagedOptPropXData(String managedOptPropName) {
    return _formModelStructure._getCurrentManagedOptPropXData(
      propName: managedOptPropName,
    );
  }

  /// Retrieves the current data value for a managed-option property.
  dynamic getManagedOptPropData(String managedOptPropName) {
    return _formModelStructure._getCurrentManagedOptPropData(
      propName: managedOptPropName,
    );
  }

  /// Finds and returns a managed-option form property model by its name.
  ManagedOptFormPropModel? findManagedOptFormProp(
      {required String managedOptPropName}) {
    return _formModelStructure._findManagedOptFormProp(managedOptPropName);
  }

  /// Returns the debug load count for a specific managed-option property.
  int debugGetManagedOptPropLoadCount(String managedOptPropName) {
    return _formModelStructure._debugGetManagedOptPropLoadCount(
      managedOptPropName: managedOptPropName,
    );
  }

  /// Checks whether form fields can be patched based on current system and form state.
  Actionable<FormModelPatchFormFieldsPrecheck> _checkBeforePatchFormFields({
    required bool checkBusy,
  }) {
    return FormModelPatchFormFieldsPrecheckUtils.checkBeforePatchFormFields(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      formDataState: dataState,
    );
  }

  // ===========================================================================
  // UNIFIED LIFECYCLE: START NEW FORM ACTIVITY
  // ===========================================================================

  /// Central lifecycle coordinator for Form data mutation, initialization, and validation.
  @_ImportantMethodAnnotation(
      "Called when Form Data is being loaded or user makes changes in FormView")
  Future<bool> _startNewFormActivity({
    required ExecutionTrace executionTrace,
    required FORM_PATCH? formPatch,
    required final FormActivityType activityType,
    required Map<String, dynamic>? formKeyInstantValuesInUI,
  }) async {
    debug._formActivityCount++;

    executionTrace.addInfo(
      codeId: "#006000",
      shortDesc: "${debugObjHtml(this)} on _startNewFormActivity().",
      parameters: {
        "activityType": activityType,
        "formPatch": formPatch,
      },
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
        if (relatedModule is Shelf) {
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
          _creationFormPatch = formPatch;
        } else {
          _creationFormPatch = null;
        }
        executionTrace.addNonControllableCall(
          codeId: "#006200",
          caller: this,
          methodName: '_performLoadAdditionalFormRelatedData',
          suffixShortDesc: 'To get additionalFormRelatedData.',
        );
        additionalFormRelatedData =
            await _performLoadAdditionalFormRelatedData(executionTrace);
        // Null is error.
        if (additionalFormRelatedData == null) {
          return false;
        }
        _additionalFormRelatedData = additionalFormRelatedData;
        break;

      case FormActivityType.updateFromFormView:
        currentFormMode = _internalFormMode;
        if (formPatch != null) {
          throw DevError(
            errorMessage:
                "Dev Error. formPatch must be null if FormModel.activityType = updateFromFormView.",
          );
        }
        if (currentFormMode == InternalFormMode.creation) {
          formPatch = _creationFormPatch;
        }
        additionalFormRelatedData = _additionalFormRelatedData;
        if (additionalFormRelatedData == null) {
          // TODO: Fix Error here.
          throw DevError(
            errorMessage:
                "Dev Error. _additionalFormRelatedData is null in updateFromFormView.",
          );
        }
        break;

      case FormActivityType.patchFormFields:
        currentFormMode = _internalFormMode;
        if (formPatch == null) {
          throw DevError(
            errorMessage:
                "Dev Error. formPatch must be not null if FormModel.activityType = patchFormFields.",
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
        _defaultPlainValuesInitiated = false;
        _defaultManagedOptValuesInitiated = false;
      }
    }

    final Map<String, dynamic> formKeyInstantValues =
        formKeyInstantValuesInUI ?? _formModelStructure._currentFormData;

    _formModelStructure._setupTemporaryStateForNewActivity(
      activityType: activityType,
      formKeyInstantValues: formKeyInstantValues,
    );

    // =========================================================================
    // POPULATE PLAIN PROPERTIES
    // =========================================================================
    if (activityType == FormActivityType.startCreatingOrEditing) {
      executionTrace.addInfo(
        codeId: "#006180",
        shortDesc: "Populating plain form properties."
            "\n - @activityType: <b>$activityType</b>."
            "\n - @domainData: ${debugObjHtml(domainData)}.",
      );
      try {
        final Map<String, dynamic> plainPropValueMap =
            _internalResolveInitialPlainPropValues(
                  executionTrace: executionTrace,
                  additionalFormRelatedData: additionalFormRelatedData,
                ) ??
                {};

        for (String propName in plainPropValueMap.keys) {
          __throwErrorIfNotAPlainPropName(
            propName: propName,
            formErrorMethod:
                FormErrorMethod.extractPlainPropValuesFromItemDetail,
          );
          dynamic value = plainPropValueMap[propName];
          _formModelStructure._setTempPlainPropValue(
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
          formErrorMethod: FormErrorMethod.extractPlainPropValuesFromItemDetail,
          error: error,
          errorStackTrace: stackTrace,
        );
        _formModelStructure._setFormError(formErrorInfo);

        final ErrorInfo errorInfo = _handleError(
          module: relatedModule,
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
              "The ${debugObjHtml(this)}._internalResolveInitialPlainPropValues() method encountered an error!",
          errorInfo: errorInfo,
        );
        return false;
      }

      // Apply external FormPatch overrides if present
      if (formPatch != null) {
        try {
          executionTrace.addControllableCall(
            codeId: "#006620",
            caller: this,
            methodName: "extractPatchValuesForPlainProps",
            suffixShortDesc: "",
            parameters: {
              "formPatch": formPatch,
            },
          );
          final Map<String, PlainValueWrap?> patchPlainPropValues =
              extractPatchValuesForPlainProps(
                    formPatch: formPatch,
                  ) ??
                  {};

          for (String propName in patchPlainPropValues.keys) {
            __throwErrorIfNotAPlainPropName(
              propName: propName,
              formErrorMethod: FormErrorMethod.extractPatchValuesForPlainProps,
            );
            PlainValueWrap? valueWrap = patchPlainPropValues[propName];
            if (valueWrap != null && valueWrap.use) {
              _formModelStructure._setTempPlainPropValue(
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
            formErrorMethod: FormErrorMethod.extractPatchValuesForPlainProps,
            error: e,
            errorStackTrace: stackTrace,
          );
          _formModelStructure._setFormError(formErrorInfo);

          final ErrorInfo errorInfo = _handleError(
            module: relatedModule,
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
      if (formPatch != null) {
        try {
          executionTrace.addControllableCall(
            codeId: "#006720",
            caller: this,
            methodName: "extractPatchValuesForPlainProps",
            suffixShortDesc: "",
            parameters: {
              "formPatch": formPatch,
            },
          );
          final Map<String, PlainValueWrap?> updatedPlainPropValues =
              extractPatchValuesForPlainProps(
                    formPatch: formPatch,
                  ) ??
                  {};

          for (String propName in updatedPlainPropValues.keys) {
            __throwErrorIfNotAPlainPropName(
              propName: propName,
              formErrorMethod: FormErrorMethod.extractPatchValuesForPlainProps,
            );
            PlainValueWrap? valueWrap = updatedPlainPropValues[propName];
            if (valueWrap != null && valueWrap.use) {
              _formModelStructure._setTempPlainPropValue(
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
            formErrorMethod: FormErrorMethod.extractPatchValuesForPlainProps,
            error: e,
            errorStackTrace: stackTrace,
          );
          _formModelStructure._setFormError(formErrorInfo);

          final ErrorInfo transientErrorInfo = _handleError(
            module: relatedModule,
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
    // POPULATE MANAGED-OPTION PROPERTIES (CASCADE HIERARCHY)
    // =========================================================================
    try {
      for (ManagedOptFormPropModel managedOptProp
          in _formModelStructure._rootManagedOptPropModels) {
        await _loadManagedOptPropDataCascade(
          executionTrace: executionTrace,
          additionalFormRelatedData: additionalFormRelatedData,
          formPatch: formPatch,
          parentManagedOptPropValue: null,
          parentValueIsInitialValue: true,
          managedOptProp: managedOptProp,
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
        module: relatedModule,
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
  // UNIFIED MANAGED-OPTION PROP DATA LOADING (CASCADE)
  // ===========================================================================

  /// Recursively loads managed-option property data down the hierarchical cascade.
  Future<void> _loadManagedOptPropDataCascade({
    required final ExecutionTrace executionTrace,
    required final FormActivityType activityType,
    required final ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required final FORM_PATCH? formPatch,
    required final Object? parentManagedOptPropValue,
    required final ManagedOptFormPropModel managedOptProp,
    required final bool parentValueIsInitialValue,
    required final Map<String, dynamic> formKeyInstantValues,
  }) async {
    final String managedOptPropName = managedOptProp.propName;
    final ManagedOptSelectionMode selectionMode = managedOptProp.selectionMode;

    executionTrace.addInfo(
      codeId: "#017000",
      shortDesc:
          "Loading Data for ${debugObjHtml(managedOptProp)} and its children..",
    );

    XData? tempManagedOptPropXData =
        _formModelStructure._getTempManagedOptPropXData(
      propName: managedOptPropName,
    );

    final dynamic tempInitialManagedOptValue = _formModelStructure
        ._getTempInitialPropValue(propName: managedOptPropName);
    final dynamic tempCurrentManagedOptValue = _formModelStructure
        ._getTempCurrentPropValue(propName: managedOptPropName);

    dynamic newSelectedValue = _formModelStructure._getTempCurrentPropValue(
      propName: managedOptPropName,
    );
    if (activityType == FormActivityType.updateFromFormView) {
      if (formKeyInstantValues.containsKey(managedOptPropName)) {
        newSelectedValue = formKeyInstantValues[managedOptPropName];
      }
    }

    final bool valueChanged;
    if (tempManagedOptPropXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempManagedOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentManagedOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }

    final bool managedOptValueIsInitialValue;
    if (tempManagedOptPropXData == null) {
      managedOptValueIsInitialValue = false;
    } else {
      managedOptValueIsInitialValue =
          tempManagedOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempInitialManagedOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }

    managedOptProp._tempCurrentValue = newSelectedValue;

    if (valueChanged) {
      _formModelStructure._updateChildrenManagedOptValueToNullCascade(
        managedOptProp: managedOptProp,
      );
    }

    if (tempManagedOptPropXData == null) {
      _formModelStructure._setTempManagedOptPropXData(
        managedOptPropName: managedOptPropName,
        managedOptPropXData: null,
      );
      _formModelStructure._updatePropsTempValues({
        managedOptPropName: null,
      });
    }

    bool forceReload = activityType != FormActivityType.updateFromFormView &&
        managedOptProp.parent == null &&
        managedOptProp._markToReload;

    if (tempManagedOptPropXData == null || forceReload) {
      managedOptProp._loadCount++;
      try {
        executionTrace.addControllableCall(
          codeId: "#017400",
          caller: this,
          methodName: "performLoadManagedOptPropXData",
          suffixShortDesc: "",
          parameters: {
            "managedOptPropName": managedOptPropName,
            "parentManagedOptPropValue": parentManagedOptPropValue,
            "managedOptSelectionMode": selectionMode,
            "rawDomainData": rawDomainData,
            "formPatch": formPatch,
            "additionalFormRelatedData": additionalFormRelatedData,
          },
        );
        tempManagedOptPropXData = await _internalPerformLoadManagedOptPropXData(
          rawDomainData: rawDomainData,
          additionalFormRelatedData: additionalFormRelatedData,
          parentManagedOptPropValue: parentManagedOptPropValue,
          managedOptPropName: managedOptPropName,
          managedOptSelectionMode: selectionMode,
        );
      } catch (e, stackTrace) {
        throw FormMethodError(
          propName: managedOptPropName,
          formErrorMethod: FormErrorMethod.performLoadManagedOptPropXData,
          error: e,
          stackTrace: stackTrace,
        );
      }

      managedOptProp._markToReload = false;
      managedOptProp._tempCurrentXData = tempManagedOptPropXData;
    }

    List? currentSelectedItems;
    List? candidateSelectedItems;
    OptValueWrap? initialValueWrap;

    if (tempManagedOptPropXData != null) {
      if (activityType == FormActivityType.startCreatingOrEditing) {
        initialValueWrap = _internalResolveInitialManagedOptPropValue(
          executionTrace: executionTrace,
          managedOptPropName: managedOptPropName,
          managedOptSelectionMode: selectionMode,
          managedOptPropXData: tempManagedOptPropXData,
          parentManagedOptPropValue: parentManagedOptPropValue,
          additionalFormRelatedData: additionalFormRelatedData,
        );

        if (formPatch != null && formPatch is! EmptyFormPatch) {
          initialValueWrap = __extractPatchValueForManagedOptProp(
            executionTrace: executionTrace,
            formPatch: formPatch,
            managedOptPropXData: tempManagedOptPropXData,
            managedOptPropName: managedOptPropName,
            managedOptSelectionMode: selectionMode,
            parentManagedOptPropValue: parentManagedOptPropValue,
          );
        }
      } else if (activityType == FormActivityType.patchFormFields) {
        if (formPatch != null && formPatch is! EmptyFormPatch) {
          initialValueWrap = __extractPatchValueForManagedOptProp(
            executionTrace: executionTrace,
            formPatch: formPatch,
            managedOptPropXData: tempManagedOptPropXData,
            managedOptPropName: managedOptPropName,
            managedOptSelectionMode: selectionMode,
            parentManagedOptPropValue: parentManagedOptPropValue,
          );
        }
      }

      final dynamic tempCurrentValue =
          _formModelStructure._getTempCurrentPropValue(
        propName: managedOptPropName,
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
        currentSelectedItems = tempManagedOptPropXData._resolveItemsFromRawData(
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

    _formModelStructure._setTempManagedOptPropXData(
      managedOptPropName: managedOptPropName,
      managedOptPropXData: tempManagedOptPropXData,
    );

    final dynamic initialValue;
    if (activityType == FormActivityType.startCreatingOrEditing) {
      initialValue = initialValueWrap?.values;
    } else {
      initialValue = _formModelStructure._getInitialPropValue(
        propName: managedOptPropName,
      );
    }

    if (activityType == FormActivityType.startCreatingOrEditing ||
        parentValueIsInitialValue) {
      tempManagedOptPropXData?._addInitialValueIfOrphan(
        initialValue: initialValue,
        removeCurrentOrphanItems: true,
      );
    }

    candidateSelectedItems = tempManagedOptPropXData?._resolveItemsFromRawData(
          dynamicValues: candidateSelectedItems,
          addOrphan: true,
          clearOrphanItems: false,
        ) ??
        [];

    if (candidateSelectedItems.isNotEmpty) {
      if (managedOptProp.selectionMode == ManagedOptSelectionMode.single) {
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _formModelStructure._updatePropsTempValues({
          managedOptPropName: candidateSelectedItem,
        });
      } else {
        _formModelStructure._updatePropsTempValues({
          managedOptPropName: candidateSelectedItems,
        });
      }
    } else {
      _formModelStructure._updatePropsTempValues({
        managedOptPropName: null,
      });
    }

    Object? tempSelectedPropValue =
        _formModelStructure._getTempCurrentPropValue(
      propName: managedOptPropName,
    );

    if (tempSelectedPropValue != null) {
      for (ManagedOptFormPropModel child in managedOptProp._children) {
        await _loadManagedOptPropDataCascade(
          executionTrace: executionTrace,
          additionalFormRelatedData: additionalFormRelatedData,
          formPatch: formPatch,
          parentManagedOptPropValue: tempSelectedPropValue,
          parentValueIsInitialValue: managedOptValueIsInitialValue,
          managedOptProp: child,
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
        module: relatedModule,
        methodName: "performLoadAdditionalFormRelatedData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      final formDataStateFatalError = FormDataStateFatalError(
        errorInfo: errorInfo,
      );
      _formModelStructure._setFormDataState(
        formDataState: formDataStateFatalError,
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
        module: relatedModule,
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

  /// Extracts update values for a managed-option property from form input.
  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractPatchValueForManagedOptProp({
    required ExecutionTrace executionTrace,
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required FORM_PATCH formPatch,
    required Object? parentManagedOptPropValue,
  }) {
    if (formPatch is EmptyFormPatch) return null;
    try {
      executionTrace.addControllableCall(
        codeId: "#018000",
        caller: this,
        methodName: "extractPatchValueForManagedOptProp",
        suffixShortDesc: "",
        parameters: {
          "managedOptPropName": managedOptPropName,
          "managedOptPropXData": managedOptPropXData,
          "managedOptSelectionMode": managedOptSelectionMode,
          "parentManagedOptPropValue": parentManagedOptPropValue,
          "formPatch": formPatch,
        },
      );
      OptValueWrap? valueWrap = extractPatchValueForManagedOptProp(
        managedOptPropName: managedOptPropName,
        managedOptPropXData: managedOptPropXData,
        managedOptSelectionMode: managedOptSelectionMode,
        parentManagedOptPropValue: parentManagedOptPropValue,
        formPatch: formPatch,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractPatchValueForManagedOptProp",
          managedOptPropName: managedOptPropName,
        );
      }
      List? value = valueWrap?.values ?? [];
      return OptValueWrap.multi(
        managedOptPropXData._resolveItemsFromRawData(
          dynamicValues: value,
          addOrphan: true,
          clearOrphanItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw FormMethodError(
        propName: managedOptPropName,
        formErrorMethod: FormErrorMethod.extractPatchValueForManagedOptProp,
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
        module: relatedModule,
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

  /// Throws an error when a method returns a null value wrap for a managed-option property.
  void __createNullValueWrapAppError({
    required String methodName,
    required String managedOptPropName,
  }) {
    ManagedOptFormPropModel? managedOptProp =
        _formModelStructure._getManagedOptFormProp(managedOptPropName);
    if (managedOptProp == null) {
      throw "The '$managedOptPropName' is not $ManagedOptFormPropModel";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the managedOptPropName '$managedOptPropName'. ";
    if (managedOptProp.selectionMode == ManagedOptSelectionMode.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $ManagedOptFormPropModel. See the specification of this method for more information.";
  }

  /// Throws an error if the provided property name does not correspond to a plain property.
  void __throwErrorIfNotAPlainPropName({
    required String propName,
    required FormErrorMethod formErrorMethod,
  }) {
    if (_formModelStructure._isManagedOptFormProp(propName)) {
      throw DevError(
        errorMessage:
            '$propName is not a ${getTypeNameWithoutGenerics(PlainFormPropModel)}',
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

  /// Extracts update values for plain properties from form input.
  @AbstractMethodAnnotation()
  Map<String, PlainValueWrap?>? extractPatchValuesForPlainProps({
    required FORM_PATCH formPatch,
  });

  /// Extracts update value for a managed-option property from form input.
  @AbstractMethodAnnotation()
  OptValueWrap? extractPatchValueForManagedOptProp({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required FORM_PATCH formPatch,
  });

  /// Defines the form model structure containing properties, fields, and options.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// FormModelStructure defineFormModelStructure() {
  ///   return FormModelStructure(
  ///     plainPropDefs: [
  ///       PlainFormPropDef<int>(propName: "id"),
  ///       PlainFormPropDef<String>(propName: "name"),
  ///       PlainFormPropDef<bool>(propName: "active"),
  ///       PlainFormPropDef<String>(propName: "description"),
  ///     ],
  ///     managedOptPropDefs: [
  ///       ManagedOptFormPropDef<ProgramTypeInfo>.singleSelection(
  ///         propName: "programType",
  ///       ),
  ///       // Managed-option multi-selection Criterion.
  ///       ManagedOptFormPropDef<ContributorInfo>.multiSelection(
  ///         propName: "contributors",
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @AbstractMethodAnnotation()
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
  @AbstractMethodAnnotation()
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

  /// Checks whether the FormModel debug inspector dialog can be opened.
  @_PrecheckMethod()
  Actionable<ShowFormModelInspectorPrecheck>
      checkBeforeShowFormModelInspector() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return ShowFormModelInspectorPrecheckUtils
        .checkBeforeShowFormModelInspector(
      hasForm: true,
      loggedInUser: loggedInUser,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Opens the FormModel debug inspector dialog if permitted.
  ///
  /// Displays an error snackbar using the precheck's [message] and [details]
  /// if the precheck fails and [showErrorSnackBar] is `true`.
  @_RootMethodAnnotation()
  Future<Actionable<ShowFormModelInspectorPrecheck>>
      showDebugFormModelInspector({
    String locationInfo = '',
    bool showErrorSnackBar = true,
  }) async {
    final Actionable<ShowFormModelInspectorPrecheck> actionable =
        checkBeforeShowFormModelInspector();

    if (!actionable.yes) {
      if (showErrorSnackBar) {
        final ShowFormModelInspectorPrecheck err = actionable.errCode!;
        this.showErrorSnackBar(
          message: err.message,
          errorDetails: err.details,
        );
      }
      return actionable;
    }

    final BuildContext context = FlutterArtistCore.context;
    await DebugFormModelInspectorDialog.show(
      context: context,
      locationInfo: locationInfo,
      formModel: this,
    );
    return actionable;
  }
}
