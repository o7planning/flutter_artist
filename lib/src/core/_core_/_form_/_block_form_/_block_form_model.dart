part of '../../core.dart';

abstract class BlockFormModel<
        ID extends Comparable,
        ITEM_DETAIL extends Identifiable<ID>,
        CREATION_PRESET extends CreationPreset,
        FORM_PATCH extends FormPatch,
        FORM_OUTPUT extends FormOutput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<
        FORM_PATCH, //
        FORM_OUTPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  @override
  Map<String, Type> getGenericsInfoMap() {
    return {
      "ID": ID,
      "ITEM_DETAIL": ITEM_DETAIL,
      "CREATION_PRESET": CREATION_PRESET,
      "FORM_PATCH": FORM_PATCH,
      "FORM_OUTPUT": FORM_OUTPUT,
      "ADDITIONAL_FORM_RELATED_DATA": ADDITIONAL_FORM_RELATED_DATA,
    };
  }

  Block<
      ID, //
      Identifiable<ID>,
      ITEM_DETAIL,
      FilterPatch,
      FilterCriteria,
      CREATION_PRESET,
      FORM_PATCH> get block => blockCurrentItemModel.block;

  late final BlockCurrentItemModel<
      ID, //
      Identifiable<ID>,
      ITEM_DETAIL,
      FilterPatch,
      FilterCriteria,
      CREATION_PRESET,
      FORM_PATCH> blockCurrentItemModel;

  @override
  String get name => block.name;

  @override
  Shelf get module => block.module;

  @override
  Block get host => block;

  @override
  String get pathInfo => "${shelf.name} > ${block.name} > block-form";

  Shelf get shelf => block.shelf;

  @override
  Shelf get relatedModule => shelf;

  @override
  Object? get rawDomainData => block.currentItemDetail;

  @override
  BlockFormMode get formMode => _internalFormMode.toBlockFormMode();

  BlockFormModel({super.config});

  @override
  bool get hasError => dataState.isFatalError;

  XBlockFormModel<ID, ITEM_DETAIL, FORM_PATCH> _createXBlockFormModel({
    required FORM_PATCH? formPatch,
  }) {
    return XBlockFormModel<ID, ITEM_DETAIL, FORM_PATCH>._(
      formModel: this,
      formPatch: formPatch,
    );
  }

  // ===========================================================================

  Type getCreationPresetType() => CREATION_PRESET;

  // ===========================================================================
  // POLYMORPHIC BRIDGES IMPLEMENTATION
  // ===========================================================================

  @override
  Map<String, dynamic>? _internalResolveInitialPlainPropValues({
    required ExecutionTrace executionTrace,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    final ITEM_DETAIL? itemDetail = block.currentItemDetail;
    final ancestorContext = BlockAncestorContext(currentBlock: block);

    if (itemDetail != null) {
      executionTrace.addControllableCall(
        codeId: "#006200",
        caller: this,
        methodName: "extractPlainPropValuesFromItemDetail",
        suffixShortDesc: "",
        parameters: {
          "ancestorContext": ancestorContext,
          "additionalFormRelatedData": additionalFormRelatedData,
          "itemDetail": itemDetail,
        },
      );
      return extractPlainPropValuesFromItemDetail(
        ancestorContext: ancestorContext,
        additionalFormRelatedData: additionalFormRelatedData,
        itemDetail: itemDetail,
      );
    } else {
      final CREATION_PRESET? creationPreset =
          block._buildCreationPreset(executionTrace);
      if (creationPreset == null) {
        return null;
      }
      executionTrace.addControllableCall(
        codeId: "#006540",
        caller: this,
        methodName: "specifyCreationValuesForPlainProps",
        suffixShortDesc: "",
        parameters: {
          "ancestorContext": ancestorContext,
          "creationPreset": creationPreset,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      return specifyCreationValuesForPlainProps(
        ancestorContext: ancestorContext,
        creationPreset: creationPreset,
        additionalFormRelatedData: additionalFormRelatedData,
      );
    }
  }

  @override
  OptValueWrap? _internalResolveInitialManagedOptPropValue({
    required ExecutionTrace executionTrace,
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    final ITEM_DETAIL? itemDetail = block.currentItemDetail;
    final ancestorContext = BlockAncestorContext(currentBlock: block);

    if (itemDetail != null) {
      executionTrace.addControllableCall(
        codeId: "#032000",
        caller: this,
        methodName: "extractManagedOptPropValueFromItemDetail",
        suffixShortDesc: "",
        parameters: {
          "managedOptPropName": managedOptPropName,
          "parentManagedOptPropValue": parentManagedOptPropValue,
          "managedOptSelectionMode": managedOptSelectionMode,
          "managedOptPropXData": managedOptPropXData,
          "itemDetail": itemDetail,
          "ancestorContext": ancestorContext,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      OptValueWrap? valueWrap = extractManagedOptPropValueFromItemDetail(
        managedOptPropName: managedOptPropName,
        managedOptSelectionMode: managedOptSelectionMode,
        managedOptPropXData: managedOptPropXData,
        itemDetail: itemDetail,
        parentManagedOptPropValue: parentManagedOptPropValue,
        ancestorContext: ancestorContext,
        additionalFormRelatedData: additionalFormRelatedData,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractManagedOptPropValueFromItemDetail",
          managedOptPropName: managedOptPropName,
        );
      }
      return valueWrap;
    } else {
      if (_defaultManagedOptValuesInitiated) {
        return null;
      }
      final CREATION_PRESET? creationPreset =
          block._buildCreationPreset(executionTrace);
      if (creationPreset == null) {
        return null;
      }
      executionTrace.addControllableCall(
        codeId: "#033000",
        caller: this,
        methodName: "specifyCreationValueForManagedOptProp",
        suffixShortDesc: "",
        parameters: {
          "managedOptPropXData": managedOptPropXData,
          "managedOptPropName": managedOptPropName,
          "managedOptSelectionMode": managedOptSelectionMode,
          "parentManagedOptPropValue": parentManagedOptPropValue,
          "ancestorContext": ancestorContext,
          "creationPreset": creationPreset,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      OptValueWrap? valueWrap = specifyCreationValueForManagedOptProp(
        managedOptPropXData: managedOptPropXData,
        managedOptPropName: managedOptPropName,
        managedOptSelectionMode: managedOptSelectionMode,
        parentManagedOptPropValue: parentManagedOptPropValue,
        ancestorContext: ancestorContext,
        creationPreset: creationPreset,
        additionalFormRelatedData: additionalFormRelatedData,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "specifyCreationValueForManagedOptProp",
          managedOptPropName: managedOptPropName,
        );
        return null;
      }
      List? value = valueWrap.values;
      return OptValueWrap.multi(
        managedOptPropXData._resolveItemsFromRawData(
          dynamicValues: value,
          addOrphan: true,
          clearOrphanItems: true,
        ),
      );
    }
  }

  @override
  Future<XData?> _internalPerformLoadManagedOptPropXData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object? rawDomainData,
  }) {
    return performLoadManagedOptPropXData(
      managedOptPropName: managedOptPropName,
      managedOptSelectionMode: managedOptSelectionMode,
      parentManagedOptPropValue: parentManagedOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
      itemDetail: rawDomainData as ITEM_DETAIL?,
    );
  }

  @override
  Future<ADDITIONAL_FORM_RELATED_DATA>
      _internalPerformLoadAdditionalFormRelatedData({
    required Object? rawDomainData,
  }) {
    return performLoadAdditionalFormRelatedData(
      ancestorContext: BlockAncestorContext(currentBlock: block),
      currentItemDetail: rawDomainData as ITEM_DETAIL?,
    );
  }

  // ===========================================================================
  // ABSTRACT CONTRACTS (User override in concrete BlockFormModel)
  // ===========================================================================

  @AbstractMethodAnnotation()
  OptValueWrap? specifyCreationValueForManagedOptProp({
    required BlockAncestorContext ancestorContext,
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @AbstractMethodAnnotation()
  Map<String, dynamic>? specifyCreationValuesForPlainProps({
    required BlockAncestorContext ancestorContext,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @AbstractMethodAnnotation()
  Future<XData?> performLoadManagedOptPropXData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL? itemDetail,
  });

  @AbstractMethodAnnotation()
  Map<String, dynamic>? extractPlainPropValuesFromItemDetail({
    required BlockAncestorContext ancestorContext,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
  });

  @AbstractMethodAnnotation()
  OptValueWrap? extractManagedOptPropValueFromItemDetail({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required BlockAncestorContext ancestorContext,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
  });

  @AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required BlockAncestorContext ancestorContext,
    required ITEM_DETAIL? currentItemDetail,
  });

  @AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performCreateItem({
    required FORM_OUTPUT formData,
  });

  @AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performUpdateItem({
    required FORM_OUTPUT formData,
  });

  // ===========================================================================
  // BLOCK SPECIALIZED ACTIONS & EXECUTION UNITS
  // ===========================================================================

  Type getIdType() => ID;

  Type getItemDetailType() => ITEM_DETAIL;

  void _triggerFilterCriteriaChanged() {
    _formModelStructure._triggerFilterCriteriaChanged();
  }

  void _triggerItemIdChanged() {
    _formModelStructure._triggerItemIdChanged();
  }

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
      codeId: "#036000",
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
      formPatch: null,
      activityType: FormActivityType.updateFromFormView,
      formKeyInstantValuesInUI: executionIntent.formKeyInstantValuesInUI,
    );
    return true;
  }

  @_ExecutionUnitMethodAnnotation()
  @_BlockFormModelLoadDataAnnotation()
  Future<bool> _unitLoadFormData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockFormModel thisXBlockFormModel,
    required FormModelDataLoadIntent executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

    executionTrace.addInfo(
      codeId: "#037000",
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
    final bool forceReloadForm = switch (thisXBlockFormModel.formLoadHint) {
      FormLoadHint.force => true,
      FormLoadHint.forceIfNeed => (thisFormDataState.isNone ||
          thisFormDataState.isPending ||
          thisFormDataState.isFatalError ||
          thisFormDataState.isLoadedStale),
      FormLoadHint.auto => visibleX &&
          (thisFormDataState.isPending ||
              thisFormDataState.isFatalError ||
              thisFormDataState.isLoadedStale),
    };

    if (!forceReloadForm) {
      if (!dataState.isLoaded) {
        _clearDataWithDataState(formDataState: FormDataStatePending());
      }
      return true;
    }

    //
    final formPatch = thisXBlockFormModel.formPatch as FORM_PATCH?;
    final bool success = await _startNewFormActivity(
      executionTrace: executionTrace,
      formPatch: formPatch,
      activityType: FormActivityType.startCreatingOrEditing,
      formKeyInstantValuesInUI: null,
    );

    if (!success) {
      final ErrorInfo? fatalErrorInfo = switch (dataState) {
        FormDataStateFatalError(:final errorInfo) => errorInfo,
        _ => null,
      };
      if (fatalErrorInfo != null) {
        executionResult._setErrorInfo(errorInfo: fatalErrorInfo);
      }
    } else if (thisXBlockFormModel.focusFlag) {
      _GlobalFocusGuard.requestFocusAfterExecution(
        ActiveFocusRegion(
          moduleName: shelf.name,
          unitName: block.name,
          regionType: FocusRegionType.blockFormView,
        ),
      );
    }

    return success;
  }

  @_ExecutionUnitMethodAnnotation()
  @_FormModelPatchFormFieldsAnnotation()
  Future<bool> _unitPatchFormFields({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockFormModel thisXBlockFormModel,
    required FormModelPatchFormFieldsIntent<FORM_PATCH> executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

    executionIntent.resultWrapper._setResult(
      FormModelPatchFormFieldsResult(),
      objectCaller: this,
      methodName: '_unitPatchFormFields',
    );

    await _startNewFormActivity(
      executionTrace: executionTrace,
      formPatch: executionIntent.formPatch,
      activityType: FormActivityType.patchFormFields,
      formKeyInstantValuesInUI: null,
    );
    return true;
  }

  @_ExecutionUnitMethodAnnotation()
  @_FormModelSaveFormAnnotation()
  Future<void> _unitSaveForm({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockFormModel<ID, ITEM_DETAIL, FORM_PATCH> thisXBlockFormModel,
    required FormModelSaveIntent executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

    final executionResult = executionIntent.resultWrapper._setResult(
      BlockFormSaveResult(precheck: null),
      objectCaller: this,
      methodName: '_unitSaveForm',
    );

    FORM_OUTPUT? formOutput;
    try {
      formOutput = _getFormOutput();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "convertToFormOutput",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      return;
    } finally {
      block._refreshSavingState(isSaving: false);
    }

    String calledMethodName =
        _formModelStructure.isNew ? 'performCreateItem' : 'performUpdateItem';
    ApiResult<ITEM_DETAIL> result;
    final bool isNew = _formModelStructure.isNew;

    try {
      block._refreshSavingState(isSaving: true);
      result = isNew
          ? await performCreateItem(formData: formOutput)
          : await performUpdateItem(formData: formOutput);
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      return;
    } finally {
      block._refreshSavingState(isSaving: false);
    }

    try {
      final ErrorInfo? restErrorInfo = await block._processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlockFormModel.xBlockCurrentItemModel.xBlock,
        isNew: isNew,
        callingClassName: getClassNameWithoutGenerics(this),
        calledMethodName: calledMethodName,
        result: result,
        item: block.currentItem,
      );
      if (restErrorInfo != null) {
        executionResult._setErrorInfo(errorInfo: restErrorInfo);
      }
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  Actionable<BlockFormEnablePrecheck> checkFormEnable() {
    return block.checkFormEnable(checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  void _triggerWhenFormViewVisible() =>
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(shelf);

  @override
  bool _checkBeforeResetForm() => block.checkBeforeResetForm().yes;

  @override
  void _refreshAllViews() => shelf.ui.refreshAllViews();

  @override
  void _refreshControlBars() => block.ui.refreshControlBars();

  @override
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {
    final XShelf xShelf = _XShelfFormViewChange(formModel: this);
    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    xBlock.xBlockCurrentItemModel.xBlockFormModel!
        ._createAndSetFormModelExecutionIntentViewChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue(showOverlay: false);
  }

  @_RootMethodAnnotation()
  @_FormModelPatchFormFieldsAnnotation()
  Future<FormModelPatchFormFieldsResult> patchFormFields({
    required FORM_PATCH formPatch,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "patchFormFields",
      parameters: {},
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    executionTrace.addNonControllableCall(
      codeId: "#097100",
      caller: this,
      methodName: "_checkBeforePatchFormFields",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );

    final Actionable<FormModelPatchFormFieldsPrecheck> actionable =
        _checkBeforePatchFormFields(
      checkBusy: checkBusyTrue,
    );
    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#097200",
        prefixShortDesc: '_checkBeforePatchFormFields()',
        module: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormModelPatchFormFieldsResult(precheck: actionable.errCode);
    }

    final XShelf xShelf = _XShelfBlockFormModelPatchFormFields(formModel: this);
    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    final executionIntent = xBlock.xBlockCurrentItemModel.xBlockFormModel!
        ._createAndSetFormModelExecutionIntentPatchFormFields(
            formPatch: formPatch);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  @_FormModelSaveFormAnnotation()
  Future<BlockFormSaveResult> saveForm() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "saveForm",
      parameters: null,
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkValidateTrue = true;

    executionTrace.addNonControllableCall(
      codeId: "#099000",
      caller: blockCurrentItemModel,
      methodName: "_checkBeforeSaveForm",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    Actionable<BlockFormSavePrecheck> actionable =
        blockCurrentItemModel._checkBeforeSaveForm(
      checkBusy: checkBusyTrue,
      checkValidate: checkValidateTrue,
    );
    if (!actionable.yes) {
      if (actionable.errCode == BlockFormSavePrecheck.formInvalidated) {
        // Send a signal to FormModel UI to locate and focus the currently displayed FormView
        block.formModel?.ui.focusFirstErrorField();
      }
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#099100",
        prefixShortDesc: '_checkBeforeSaveForm()',
        module: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockFormSaveResult(precheck: actionable.errCode);
    }

    final XShelf xShelf = _XShelfFormModelSave(formModel: this);
    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    final executionIntent = xBlock.xBlockCurrentItemModel.xBlockFormModel!
        ._createAndSetFormModelExecutionIntentSave();

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  void __assertThisXBlockFormModel(XBlockFormModel thisXBlockFormModel) {
    if (!identical(thisXBlockFormModel.formModel, this)) {
      throw "Error Assert form model: ${thisXBlockFormModel.formModel} - $this";
    }
  }
}
