part of '../../core.dart';

abstract class BlockFormModel<
        ID extends Comparable,
        ITEM_DETAIL extends Identifiable<ID>,
        CREATION_PRESET extends CreationPreset,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<
        CREATION_PRESET, //
        FORM_INPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  @override
  String get pathInfo {
    return "${shelf.name} > ${block.name} > block-form";
  }

  ADDITIONAL_FORM_RELATED_DATA? _additionalFormRelatedData;
  FORM_INPUT? _creationFormInput;

  Shelf get shelf => block.shelf;

  late final Block<
      ID, //
      Identifiable<ID>, // ITEM
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      CREATION_PRESET,
      FORM_INPUT> block;

  bool _defaultSimpleValuesInitiated = false;
  bool _defaultMultiOptValuesInitiated = false;

  bool get defaultSimpleValuesInitiated => _defaultSimpleValuesInitiated;

  bool get defaultMultiOptValuesInitiated => _defaultMultiOptValuesInitiated;

  // ***************************************************************************
  // ***************************************************************************

  BlockFormModel({
    super.config,
  });

  // ***************************************************************************

  XBlockFormModel<ID, ITEM_DETAIL> _createXBlockFormModel({
    required FORM_INPUT? formInput,
  }) {
    return XBlockFormModel<ID, ITEM_DETAIL>._(
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
    required ITEM_DETAIL? itemDetail,
  });

  // ===========================================================================
  // PAIR 1: CREATION PHASE (Evaluated only during FormMode.creation)
  // ===========================================================================

  /// Supplies baseline initial values for simple form properties during Creation mode.
  ///
  /// Combines [ancestorContext], [creationPreset] (derived from filter criteria),
  /// and [additionalFormRelatedData].
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyCreationValuesForSimpleProps({
    required BlockAncestorContext ancestorContext,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  /// Resolves the initial selection wrapper for a multi-option property during Creation mode.
  @_AbstractMethodAnnotation()
  OptValueWrap? specifyCreationValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required BlockAncestorContext ancestorContext,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  // ===========================================================================
  // PAIR 2: EDIT PHASE (Evaluated only during FormMode.edit)
  // ===========================================================================

  /// Extracts values from the persisted [itemDetail] to populate simple form fields.
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? extractSimplePropValuesFromItemDetail({
    required BlockAncestorContext ancestorContext,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
  });

  /// Extracts selection wrappers from the persisted [itemDetail] for a multi-option property.
  @_AbstractMethodAnnotation()
  OptValueWrap? extractMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required BlockAncestorContext ancestorContext,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
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
  // AUXILIARY & REMOTE PERSISTENCE OPERATIONS
  // ===========================================================================

  /// Asynchronously fetches auxiliary metadata specifically required for form display.
  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required BlockAncestorContext ancestorContext,
    required ITEM_DETAIL? currentItemDetail,
  });

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performCreateItem({
    required Map<String, dynamic> formMapData,
  });

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performUpdateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Type getIdType() => ID;

  Type getItemDetailType() => ITEM_DETAIL;

  Type getFormInputType() => FORM_INPUT;

  @DebugMethodAnnotation()
  String get debugClassDefinition =>
      "${getClassName(this)}$debugClassParametersDefinition";

  @DebugMethodAnnotation()
  String get debugClassParametersDefinition =>
      "<${getIdType()}, ${getItemDetailType()}, ${getFormInputType()}>";

  // ***************************************************************************
  // ***************************************************************************

  void _triggerFilterCriteriaChanged() {
    _formModelStructure._triggerFilterCriteriaChanged();
  }

  void _triggerItemIdChanged() {
    _formModelStructure._triggerItemIdChanged();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_FormViewChangeAnnotation()
  Future<bool> _unitFormViewChanged({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockFormModel thisXBlockFormModel,
    required FormModelViewChangeIntent executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

    executionTrace.addInfo(
      codeId: "#36000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
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
  @_FormModelLoadDataAnnotation()
  Future<bool> _unitLoadFormData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockFormModel thisXBlockFormModel,
    required FormModelDataLoadIntent executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

    executionTrace.addInfo(
      codeId: "#37000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      FormModelDataLoadResult(),
      objectCaller: this,
      methodName: '_unitLoadFormData',
    );

    final visibleX = ui.hasVisibleViews();
    final thisFormDataState = dataState;
    final bool forceReloadForm;
    switch (thisXBlockFormModel.formLoadHint) {
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
      codeId: "#37060",
      shortDesc:
          "Calculate >> @forceReloadForm: ${debugObjHtml(forceReloadForm)}",
    );

    if (!forceReloadForm) {
      if (!dataState.isLoaded) {
        executionTrace.addInfo(
          codeId: "#37100",
          shortDesc:
              "${debugObjHtml(this)} - @dataState: ${debugObjHtml(dataState)} --> Clear data and set to <b>pending</b>.",
        );
        _clearDataWithDataState(formDataState: FormDataStatePending());
      }
      executionTrace.addInfo(
        codeId: "#37120",
        shortDesc:
            "@forceReloadForm: ${debugObjHtml(forceReloadForm)} --> do nothing.",
      );
      return true;
    }

    // Synchronously construct creation preset
    final CREATION_PRESET? creationPreset =
        block._buildCreationPreset(executionTrace);
    if (creationPreset == null) {
      return false;
    }

    final formInput = thisXBlockFormModel.formInput as FORM_INPUT?;
    final activityType = FormActivityType.startCreatingOrEditing;

    executionTrace.addNonControllableCall(
      codeId: "#37260",
      caller: this,
      methodName: "_startNewFormActivity",
      suffixShortDesc: "",
      parameters: {
        "activityType": activityType,
        "formInput": formInput,
        "creationPreset": creationPreset,
      },
    );

    return await _startNewFormActivity(
      executionTrace: executionTrace,
      creationPreset: creationPreset,
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
    required XBlockFormModel thisXBlockFormModel,
    required FormModelPatchFormFieldsIntent<FORM_INPUT> executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

    executionTrace.addInfo(
      codeId: "#38000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
    );
    final executionResult = executionIntent.resultWrapper._setResult(
      FormModelPatchFormFieldsResult(),
      objectCaller: this,
      methodName: '_unitPatchFormFields',
    );

    final activityType = FormActivityType.patchFormFields;

    executionTrace.addNonControllableCall(
      codeId: "#38100",
      caller: this,
      methodName: "_startNewFormActivity",
      suffixShortDesc: "",
      parameters: {
        "activityType": activityType,
        "formInput": executionIntent.formInput,
        "creationPreset": null,
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

  @_ExecutionUnitMethodAnnotation()
  @_FormModelSaveFormAnnotation()
  Future<void> _unitSaveForm({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockFormModel<ID, ITEM_DETAIL> thisXBlockFormModel,
    required FormModelSaveIntent executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

    executionTrace.addInfo(
      codeId: "#11000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      BlockFormSaveResult(precheck: null),
      objectCaller: this,
      methodName: '_unitSaveForm',
    );

    final Map<String, dynamic> formMapData =
        _formModelStructure._currentFormData;

    String calledMethodName =
        _formModelStructure.isNew ? 'performCreateItem' : 'performUpdateItem';

    ApiResult<ITEM_DETAIL> result;
    bool saveError = false;
    final bool isNew = _formModelStructure.isNew;
    try {
      block._refreshSavingState(isSaving: true);

      executionTrace.addControllableCall(
        codeId: "#11400",
        caller: this,
        methodName: calledMethodName,
        suffixShortDesc: "",
        parameters: {
          "formMapData": formMapData,
        },
      );

      result = isNew
          ? await performCreateItem(formMapData: formMapData)
          : await performUpdateItem(formMapData: formMapData);
    } catch (e, stackTrace) {
      saveError = true;

      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: isNew
            ? TipDocument.formModelPerformCreateItem
            : TipDocument.formModelPerformUpdateItem,
      );

      executionResult._setErrorInfo(
        errorInfo: errorInfo,
      );

      executionTrace.addInfo(
        codeId: "#11500",
        shortDesc:
            "The ${debugObjHtml(this)}.$calledMethodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    } finally {
      block._refreshSavingState(isSaving: false);
    }

    try {
      executionTrace.addNonControllableCall(
        codeId: "#11800",
        caller: block,
        methodName: "_processSaveActionRestResult",
        suffixShortDesc: "",
      );

      await block._processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlockFormModel.xBlock,
        isNew: isNew,
        callingClassName: getClassNameWithoutGenerics(this),
        calledMethodName: calledMethodName,
        result: result,
        item: block.currentItem,
      );
      return;
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      executionResult._setErrorInfo(
        errorInfo: errorInfo,
      );

      executionTrace.addInfo(
        codeId: "#11900",
        shortDesc:
            "The ${debugObjHtml(this)}.$calledMethodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    }
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
      codeId: "#06000",
      shortDesc: "${debugObjHtml(this)} on _startNewFormActivity().",
    );

    if (activityType == FormActivityType.startCreatingOrEditing) {
      debug._loadCount++;
      _autovalidateMode = config.autovalidateMode;
    } else {
      _autovalidateMode = config.autovalidateMode;
    }

    final ITEM_DETAIL? itemDetail = block.currentItemDetail;
    final FormMode currentFormMode;
    ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData;

    switch (activityType) {
      case FormActivityType.startCreatingOrEditing:
        currentFormMode =
            itemDetail == null ? FormMode.creation : FormMode.edit;

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

    // Initialize AncestorContext for hierarchical lookups
    final BlockAncestorContext ancestorContext =
        BlockAncestorContext(currentBlock: block);

    // =========================================================================
    // POPULATE SIMPLE PROPERTIES
    // =========================================================================
    if (activityType == FormActivityType.startCreatingOrEditing) {
      // -----------------------------------------------------------------------
      // CASE 1: EDIT MODE (itemDetail != null) -> Read persisted values
      // -----------------------------------------------------------------------
      if (itemDetail != null) {
        executionTrace.addInfo(
          codeId: "#06180",
          shortDesc: "Editing item in the form."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
        );
        try {
          executionTrace.addControllableCall(
            codeId: "#06200",
            caller: this,
            methodName: "extractSimplePropValuesFromItemDetail",
            suffixShortDesc: "",
            parameters: {
              "ancestorContext": ancestorContext,
              "additionalFormRelatedData": additionalFormRelatedData,
              "itemDetail": itemDetail,
            },
          );
          final simplePropValueMap = extractSimplePropValuesFromItemDetail(
                ancestorContext: ancestorContext,
                additionalFormRelatedData: additionalFormRelatedData,
                itemDetail: itemDetail,
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
            shelf: shelf,
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
                "The ${debugObjHtml(this)}.extractSimplePropValuesFromItemDetail() method was called with an error!",
            errorInfo: errorInfo,
          );
          return false;
        }
      }
      // -----------------------------------------------------------------------
      // CASE 2: CREATION MODE (itemDetail == null) -> Pull defaults, preset & ancestors
      // -----------------------------------------------------------------------
      else {
        executionTrace.addInfo(
          codeId: "#06500",
          shortDesc: "Creating item in the form."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
        );

        if (!_defaultSimpleValuesInitiated) {
          executionTrace.addInfo(
            codeId: "#06520",
            shortDesc:
                "@_defaultSimpleValuesInitiated = false --> Need to init creation default simple values.",
          );
          try {
            executionTrace.addControllableCall(
              codeId: "#06540",
              caller: this,
              methodName: "specifyCreationValuesForSimpleProps",
              suffixShortDesc: "",
              parameters: {
                "ancestorContext": ancestorContext,
                "creationPreset": creationPreset,
                "additionalFormRelatedData": additionalFormRelatedData,
              },
            );

            final Map<String, dynamic> simplePropValueDefault =
                specifyCreationValuesForSimpleProps(
                      ancestorContext: ancestorContext,
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
              shelf: shelf,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
              tipDocument:
                  TipDocument.formModelSpecifyDefaultValuesForSimpleProps,
            );

            final fatalErrorState =
                FormDataStateFatalError(errorInfo: errorInfo);
            __endFormActivityWithDataState(
              formDataState: fatalErrorState,
              activityType: activityType,
              error: e,
            );
            executionTrace.addInfo(
              codeId: "#06580",
              shortDesc:
                  "The ${debugObjHtml(this)}.specifyCreationValuesForSimpleProps() method was called with an error!",
              errorInfo: errorInfo,
            );
            return false;
          }
        }

        // Apply external FormInput overrides if present
        formInput ??= block.__buildFormInput(executionTrace);
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
              shelf: shelf,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
              tipDocument: TipDocument.formModelGetUpdatedValuesForSimpleProps,
            );

            final fatalErrorState =
                FormDataStateFatalError(errorInfo: errorInfo);
            __endFormActivityWithDataState(
              formDataState: fatalErrorState,
              error: e,
              activityType: activityType,
            );
            executionTrace.addInfo(
              codeId: "#06660",
              shortDesc:
                  "The ${debugObjHtml(this)}.extractUpdateValuesForSimpleProps() method was called with an error!",
              errorInfo: errorInfo,
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
      executionTrace.addInfo(
        codeId: "#06700",
        shortDesc: "Patch Form Fields."
            "\n - @activityType: <b>$activityType</b>."
            "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
      );
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
            shelf: shelf,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
            tipDocument: TipDocument.formModelGetUpdatedValuesForSimpleProps,
          );

          final formDataState = FormDataStateLoadedStale.failed(
            errorInfo: transientErrorInfo,
          );
          __endFormActivityWithDataState(
            formDataState: formDataState,
            activityType: activityType,
            error: e,
          );
          executionTrace.addInfo(
            codeId: "#06760",
            shortDesc:
                "The ${debugObjHtml(this)}.extractUpdateValuesForSimpleProps() method was called with an error!",
            errorInfo: transientErrorInfo,
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
          codeId: "#06780",
          caller: block,
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
          ancestorContext: ancestorContext,
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
        shelf: shelf,
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
      executionTrace.addInfo(
        codeId: "#06800",
        shortDesc:
            "The ${debugObjHtml(this)}.${formErrorInfo.methodName}() method was called with an error!",
        errorInfo: errorInfo,
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
          "See ${getClassNameWithoutGenerics(this)}.${getClassNameWithoutGenerics(formErrorMethod)}() method."
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

      if (_formModelStructure._formInitialDataReady) {
        if (activityType == FormActivityType.startCreatingOrEditing) {
          if (formMode == FormMode.edit &&
              _formModelStructure._formInitialDataReady) {
            final List<FormBuilderState> activeForms =
                ui._visibleFormBuilderStates;
            for (FormBuilderState formState in activeForms) {
              formState.validate(focusOnInvalid: false);
            }
          }
        }
      }

      return true;
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "__applyWithDataState",
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
    ExecutionTrace executionTrace,
  ) async {
    try {
      final ITEM_DETAIL? currentItemDetail = block.currentItemDetail;
      final ancestorContext = BlockAncestorContext(currentBlock: block);

      executionTrace.addControllableCall(
        codeId: "#91000",
        caller: this,
        methodName: "performLoadAdditionalFormRelatedData",
        suffixShortDesc: "",
        parameters: {
          "currentItemDetail": currentItemDetail,
          "ancestorContext": ancestorContext,
        },
      );
      return await performLoadAdditionalFormRelatedData(
        ancestorContext: ancestorContext,
        currentItemDetail: currentItemDetail,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "performLoadAdditionalFormRelatedData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.blockInitFormRelatedData,
      );
      final fatalErrorInfo = FormDataStateFatalError(errorInfo: errorInfo);
      _formModelStructure._setFormDataState(
        formDataState: fatalErrorInfo,
        error: e,
      );
      executionTrace.addInfo(
        codeId: "#91020",
        shortDesc:
            "The ${debugObjHtml(this)}.performLoadAdditionalFormRelatedData() method was called with an error!",
        errorInfo: errorInfo,
      );
      return null;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptPropDataCascade({
    required final ExecutionTrace executionTrace,
    required final BlockAncestorContext ancestorContext,
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
      executionTrace.addInfo(
        codeId: "#17200",
        shortDesc:
            "Value of <b>'$multiOptPropName'</b> has changed --> Clear data of all descendant <b>MultiOptFormProp(s)</b>.",
      );
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
            "itemDetail": block.currentItemDetail,
            "formInput": formInput,
            "additionalFormRelatedData": additionalFormRelatedData,
          },
        );
        tempMultiOptPropXData = await performLoadMultiOptPropXData(
          formInput: formInput,
          itemDetail: block.currentItemDetail,
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
    final ITEM_DETAIL? currentItemDetail = block.currentItemDetail;

    if (tempMultiOptPropXData != null) {
      // -----------------------------------------------------------------------
      // ITEM FIRST LOAD: RESOLVE INITIAL SELECTION WRAPPER
      // -----------------------------------------------------------------------
      if (activityType == FormActivityType.startCreatingOrEditing) {
        // CASE A: CREATION MODE (currentItemDetail == null)
        if (currentItemDetail == null) {
          executionTrace.addInfo(
            codeId: "#17500",
            shortDesc:
                "(In _loadMultiOptPropDataCascade() method for ${debugObjHtml(multiOptProp)}):",
            parameters: {
              "activityType": activityType,
              "currentItemDetail": currentItemDetail,
              "tempMultiOptPropXData": tempMultiOptPropXData,
              "formInput": formInput,
            },
          );

          if (!_defaultMultiOptValuesInitiated) {
            initialValueWrap = __specifyCreationValueForMultiOptProp(
              executionTrace: executionTrace,
              ancestorContext: ancestorContext,
              creationPreset: creationPreset!,
              additionalFormRelatedData: additionalFormRelatedData,
              multiOptPropName: multiOptPropName,
              selectionType: selectionType,
              multiOptPropXData: tempMultiOptPropXData,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
            executionTrace.addInfo(
              codeId: "#17540",
              shortDesc: "Got Value: ${debugObjHtml(initialValueWrap)}.",
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
            executionTrace.addInfo(
              codeId: "#17560",
              shortDesc: "Got Value: ${debugObjHtml(initialValueWrap)}.",
            );
          }
        }
        // CASE B: EDIT MODE (currentItemDetail != null)
        else {
          executionTrace.addInfo(
            codeId: "#17580",
            shortDesc: "Debug:",
            parameters: {
              "activityType": activityType,
              "currentItemDetail": currentItemDetail,
              "tempMultiOptPropXData": tempMultiOptPropXData,
              "formInput": formInput,
            },
          );

          initialValueWrap = __extractMultiOptPropValueFromItemDetail(
            executionTrace: executionTrace,
            ancestorContext: ancestorContext,
            additionalFormRelatedData: additionalFormRelatedData,
            itemDetail: currentItemDetail,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            selectionType: selectionType,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
          executionTrace.addInfo(
            codeId: "#17590",
            shortDesc: "Got value: ${debugObjHtml(initialValueWrap)}",
          );
        }
      }
      // -----------------------------------------------------------------------
      // PATCH FORM FIELDS: APPLY FORM INPUT OVERRIDES
      // -----------------------------------------------------------------------
      else if (activityType == FormActivityType.patchFormFields) {
        if (formInput != null && formInput is! EmptyFormInput) {
          executionTrace.addInfo(
            codeId: "#17600",
            shortDesc:
                "(In _loadMultiOptPropDataCascade() method for ${debugObjHtml(multiOptProp)}):",
            parameters: {
              "activityType": activityType,
              "currentItemDetail": currentItemDetail,
              "formInput": formInput,
            },
          );

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
          ancestorContext: ancestorContext,
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
    required BlockAncestorContext ancestorContext,
    required CREATION_PRESET creationPreset,
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
          "ancestorContext": ancestorContext,
          "creationPreset": creationPreset,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      OptValueWrap? valueWrap = specifyCreationValueForMultiOptProp(
        multiOptPropXData: multiOptPropXData,
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        parentMultiOptPropValue: parentMultiOptPropValue,
        ancestorContext: ancestorContext,
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

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractMultiOptPropValueFromItemDetail({
    required ExecutionTrace executionTrace,
    required BlockAncestorContext ancestorContext,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required ITEM_DETAIL itemDetail,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      executionTrace.addControllableCall(
        codeId: "#32000",
        caller: this,
        methodName: "extractMultiOptPropValueFromItemDetail",
        suffixShortDesc: "",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "selectionType": selectionType,
          "multiOptPropXData": multiOptPropXData,
          "itemDetail": itemDetail,
          "ancestorContext": ancestorContext,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      OptValueWrap? valueWrap = extractMultiOptPropValueFromItemDetail(
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        multiOptPropXData: multiOptPropXData,
        itemDetail: itemDetail,
        parentMultiOptPropValue: parentMultiOptPropValue,
        ancestorContext: ancestorContext,
        additionalFormRelatedData: additionalFormRelatedData,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractMultiOptPropValueFromItemDetail",
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
      block.ui.refreshControlBars();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
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
    Actionable<BlockFormEnablementPrecheck> actionable =
        block._isEnableFormToModify();
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  void _addToRecent() {
    FlutterArtist.storage._addRecentShelf(shelf);
  }

  @override
  void _triggerWhenFormViewVisible() {
    FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(shelf);
  }

  @override
  bool _canResetForm() {
    Actionable canReset = block.canResetForm();
    return canReset.yes;
  }

  @override
  void _refreshAllViews() {
    shelf.ui.refreshAllViews();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation("Called when user makes a change in FormView.")
  @_FormViewChangeAnnotation()
  @override
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {
    final XShelf xShelf = _XShelfFormViewChange(formModel: this);

    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    XBlockFormModel xBlockFormModel = xBlock.xBlockFormModel!;

    xBlockFormModel._createAndSetFormModelExecutionIntentViewChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
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

  bool __checkBeforePatchFormFields({
    required bool checkBusy,
    required bool addErrorLog,
    required bool showErrSnackBar,
  }) {
    Actionable createActionable = __canPatchFormFields(
      checkBusy: checkBusy,
    );
    if (!createActionable.yes) {
      if (addErrorLog) {
        _addErrorLogActionable(
          shelf: shelf,
          actionableFalse: createActionable,
          showErrSnackBar: showErrSnackBar,
          tipDocument: null,
        );
      }
      return false;
    }
    return true;
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
      codeId: "#78000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canPatchFormFields() to check before execute the action.",
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
        codeId: "#78040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormModelPatchFormFieldsResult(
        precheck: actionable.errCode,
      );
    }

    final XShelf xShelf = _XShelfFormModelPatchFormFields(formModel: this);

    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    XBlockFormModel xBlockFormModel = xBlock.xBlockFormModel!;

    executionTrace.addExecutionIntent(
      codeId: "#78340",
      owner: this,
      executionIntentType: FormModelPatchFormFieldsIntent,
      suffixShortDesc: "",
    );
    final executionIntent = xBlockFormModel
        ._createAndSetFormModelExecutionIntentPatchFormFields<FORM_INPUT>(
            formInput: formInput);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_FormModelSaveFormAnnotation()
  Future<BlockFormSaveResult> saveForm() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "saveForm",
      parameters: null,
      isLibMethod: true,
    );

    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    final bool checkValidateTrue = true;

    executionTrace.addInfo(
      codeId: "#79000",
      shortDesc:
          "Calling ${debugObjHtml(block)}.__canSaveForm() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
        "checkValidate": checkValidateTrue,
      },
    );

    Actionable<BlockFormSavePrecheck> actionable = block.__canSaveForm(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
      checkValidate: checkValidateTrue,
    );
    if (!actionable.yes) {
      executionTrace.addInfo(
        codeId: "#79040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );

      debug._saveErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockFormSaveResult(precheck: actionable.errCode);
    }

    final XShelf xShelf = _XShelfFormModelSave(formModel: this);

    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    XBlockFormModel xBlockFormModel = xBlock.xBlockFormModel!;

    executionTrace.addExecutionIntent(
      codeId: "#79340",
      owner: this,
      executionIntentType: FormModelSaveIntent,
      suffixShortDesc: "",
    );
    FormModelSaveIntent executionIntent =
        xBlockFormModel._createAndSetFormModelExecutionIntentSave();

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFormModelnspector() async {
    BuildContext context = FlutterArtistCore.context;

    await DebugFormModelInspectorDialog.show(
      context: context,
      locationInfo: getClassName(this),
      formModel: this,
    );
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
  // ***************************************************************************

  void __assertThisXBlockFormModel(XBlockFormModel thisXBlockFormModel) {
    if (!identical(thisXBlockFormModel.formModel, this)) {
      String message =
          "Error Assert form model: ${thisXBlockFormModel.formModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
