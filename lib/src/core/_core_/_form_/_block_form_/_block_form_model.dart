part of '../../core.dart';

abstract class BlockFormModel<
        ID extends Comparable,
        ITEM_DETAIL extends Identifiable<ID>,
        CREATION_PRESET extends CreationPreset,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<CREATION_PRESET, FORM_INPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  @override
  String get pathInfo => "${shelf.name} > ${block.name} > block-form";

  Shelf get shelf => block.shelf;

  @override
  Shelf? get relatedShelf => shelf;

  @override
  Object? get rawDomainData => block.currentItemDetail;

  @override
  BlockFormMode get formMode => _internalFormMode.toBlockFormMode();

  late final Block<ID, Identifiable<ID>, ITEM_DETAIL, FilterInput,
      FilterCriteria, CREATION_PRESET, FORM_INPUT> block;

  BlockFormModel({super.config});

  XBlockFormModel<ID, ITEM_DETAIL> _createXBlockFormModel({
    required FORM_INPUT? formInput,
  }) {
    return XBlockFormModel<ID, ITEM_DETAIL>._(
      formModel: this,
      formInput: formInput,
    );
  }

  // ===========================================================================

  @override
  String debugClassParametersDefinition() {
    return "<${getIdType()}, ${getItemDetailType()}, ${getCreationPresetType()}, ${getFormInputType()}, ${getAdditionalFormRelatedDataType()}>";
  }

  // ===========================================================================
  // POLYMORPHIC BRIDGES IMPLEMENTATION
  // ===========================================================================

  @override
  Future<XData?> _internalPerformLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required Object? rawDomainData,
  }) {
    return performLoadMultiOptPropXData(
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      parentMultiOptPropValue: parentMultiOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
      formInput: formInput,
      itemDetail: rawDomainData as ITEM_DETAIL?,
    );
  }

  @override
  Map<String, dynamic>? _internalExtractSimplePropValuesFromDomainData({
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object rawDomainData,
  }) {
    return extractSimplePropValuesFromItemDetail(
      ancestorContext: BlockAncestorContext(currentBlock: block),
      additionalFormRelatedData: additionalFormRelatedData,
      itemDetail: rawDomainData as ITEM_DETAIL,
    );
  }

  @override
  OptValueWrap? _internalExtractMultiOptPropValueFromDomainData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object rawDomainData,
  }) {
    return extractMultiOptPropValueFromItemDetail(
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      multiOptPropXData: multiOptPropXData,
      parentMultiOptPropValue: parentMultiOptPropValue,
      ancestorContext: BlockAncestorContext(currentBlock: block),
      additionalFormRelatedData: additionalFormRelatedData,
      itemDetail: rawDomainData as ITEM_DETAIL,
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

  @override
  Map<String, dynamic>? _internalSpecifyCreationValuesForSimpleProps({
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    return specifyCreationValuesForSimpleProps(
      ancestorContext: BlockAncestorContext(currentBlock: block),
      creationPreset: creationPreset,
      additionalFormRelatedData: additionalFormRelatedData,
    );
  }

  @override
  OptValueWrap? _internalSpecifyCreationValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    return specifyCreationValueForMultiOptProp(
      ancestorContext: BlockAncestorContext(currentBlock: block),
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      multiOptPropXData: multiOptPropXData,
      parentMultiOptPropValue: parentMultiOptPropValue,
      creationPreset: creationPreset,
      additionalFormRelatedData: additionalFormRelatedData,
    );
  }

  // ===========================================================================
  // ABSTRACT CONTRACTS (User override in concrete BlockFormModel)
  // ===========================================================================

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyCreationValueForMultiOptProp({
    required BlockAncestorContext ancestorContext,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyCreationValuesForSimpleProps({
    required BlockAncestorContext ancestorContext,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  Future<XData?> performLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required ITEM_DETAIL? itemDetail,
  });

  @_AbstractMethodAnnotation()
  Map<String, dynamic>? extractSimplePropValuesFromItemDetail({
    required BlockAncestorContext ancestorContext,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
  });

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
      codeId: "#36000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
    );
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
      codeId: "#37000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
    );

    executionIntent.resultWrapper._setResult(
      FormModelDataLoadResult(),
      objectCaller: this,
      methodName: '_unitLoadFormData',
    );

    final visibleX = ui.hasVisibleViews();
    final thisFormDataState = dataState;
    final bool forceReloadForm = switch (thisXBlockFormModel.formLoadHint) {
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
        _clearDataWithDataState(formDataState: FormDataStatePending());
      }
      return true;
    }

    final CREATION_PRESET? creationPreset =
        block._buildCreationPreset(executionTrace);
    if (creationPreset == null) return false;

    final formInput = thisXBlockFormModel.formInput as FORM_INPUT?;
    return await _startNewFormActivity(
      executionTrace: executionTrace,
      creationPreset: creationPreset,
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
    required XBlockFormModel thisXBlockFormModel,
    required FormModelPatchFormFieldsIntent<FORM_INPUT> executionIntent,
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
      creationPreset: null,
      formInput: executionIntent.formInput,
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
    required XBlockFormModel<ID, ITEM_DETAIL> thisXBlockFormModel,
    required FormModelSaveIntent executionIntent,
  }) async {
    __assertThisXBlockFormModel(thisXBlockFormModel);
    thisXBlockFormModel._createAndSetFormModelExecutionIntentDone();

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
    final bool isNew = _formModelStructure.isNew;

    try {
      block._refreshSavingState(isSaving: true);
      result = isNew
          ? await performCreateItem(formMapData: formMapData)
          : await performUpdateItem(formMapData: formMapData);
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
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
      await block._processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlockFormModel.xBlock,
        isNew: isNew,
        callingClassName: getClassNameWithoutGenerics(this),
        calledMethodName: calledMethodName,
        result: result,
        item: block.currentItem,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
    }
  }

  @override
  bool isEnabled() => block._isEnableFormToModify().yes;

  @override
  void _addToRecent() => FlutterArtist.storage._addRecentShelf(shelf);

  @override
  void _triggerWhenFormViewVisible() =>
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(shelf);

  @override
  bool _canResetForm() => block.canResetForm().yes;

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
    xBlock.xBlockFormModel!._createAndSetFormModelExecutionIntentViewChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue(showOverlay: false);
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
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormModelPatchFormFieldsResult(precheck: actionable.errCode);
    }

    final XShelf xShelf = _XShelfBlockFormModelPatchFormFields(formModel: this);
    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    final executionIntent = xBlock.xBlockFormModel!
        ._createAndSetFormModelExecutionIntentPatchFormFields<FORM_INPUT>(
            formInput: formInput);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  @_FormModelSaveFormAnnotation()
  Future<BlockFormSaveResult> saveForm() async {
    Actionable<BlockFormSavePrecheck> actionable = block.__canSaveForm(
      checkBusy: true,
      checkAllow: true,
      checkValidate: true,
    );
    if (!actionable.yes) {
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
    final executionIntent =
        xBlock.xBlockFormModel!._createAndSetFormModelExecutionIntentSave();

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
