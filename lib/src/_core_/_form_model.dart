part of '../../flutter_artist.dart';

abstract class FormModel<
    ID extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> extends _XBase {
  int __loadCount = 0;

  int get loadCount => __loadCount;

  int _saveErrorCount = 0;

  int get saveErrorCount => _saveErrorCount;

  int __formActivityCount = 0;

  int get formActivityCount => __formActivityCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  String get pathInfo {
    return "block-form > ${shelf.name} > ${block.name}";
  }

  bool _changeEventLocked = false;

  bool _loadTimeUIActive = false;

  bool get loadTimeUIActive => _loadTimeUIActive;

  FormMode get formMode => _formPropsStructure.formMode;

  DataState get formDataState => _formPropsStructure._formDataState;

  FormErrorInfo? get formErrorInfo => _formPropsStructure.formErrorInfo;

  bool get formInitialDataReady => _formPropsStructure._formInitialDataReady;

  Shelf get shelf => block.shelf;

  late final Block<
      ID, //
      Object,
      ITEM_DETAIL,
      FilterInput,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  bool _defaultValueInitiated = false;

  final AutovalidateMode _defaultAutovalidateMode;

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  AutovalidateMode get autovalidateMode => _autovalidateMode;

  AutovalidateMode get _autovalidateModeForFormView {
    if (_formPropsStructure._formMode == FormMode.none) {
      return AutovalidateMode.disabled;
    }
    return _autovalidateMode;
  }

  final Map<_RefreshableWidgetState, _XState> _formWidgetStates = {};

  // ***************************************************************************

  late final FormPropsStructure _formPropsStructure;

  FormPropsStructure get formPropsStructure => _formPropsStructure;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // ***************************************************************************
  // ***************************************************************************

  FormModel({
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  })  : _defaultAutovalidateMode = autovalidateMode,
        _autovalidateMode = autovalidateMode {
    __registerPropsStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// FormPropsStructure registerPropsStructure() {
  ///   return FormPropsStructure(
  ///     simpleProps: [],
  ///     multiOptProps: [
  ///       MultiOptProp(
  ///         propName: "company",
  ///         children: [
  ///           MultiOptProp(
  ///              propName: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FormPropsStructure registerPropsStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  @_AbstractMethodAnnotation()
  Future<XData?> callApiLoadMultiOptPropXData({
    required String multiOptPropName,
    required Object? parentMultiOptPropValue,
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ValueWrap? specifyDefaultMultiOptPropValue({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<Map<String, dynamic>?> specifyDefaultSimplePropValues({
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ValueWrap? getMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required ITEM_DETAIL itemDetail,
    required Object? parentMultiOptPropValue,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<Map<String, dynamic>> getSimplePropValuesFromItemDetail({
    required FILTER_CRITERIA filterCriteria,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ValueWrap? getMultiOptPropValueFromExtraFormInput({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required EXTRA_FORM_INPUT extraFormInput,
    required Object? parentMultiOptPropValue,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Map<String, dynamic>? getSimplePropValuesFromExtraFormInput({
    required EXTRA_FORM_INPUT extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> callApiCreateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> callApiUpdateItem({
    required Object? parentBlockItem,
    required FILTER_CRITERIA filterCriteria,
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Type getIdType() {
    return ID;
  }

  Type getItemDetailType() {
    return ITEM_DETAIL;
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  Type getExtraFormInputType() {
    return EXTRA_FORM_INPUT;
  }

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getIdType()}, ${getItemDetailType()}, "
        "${getFilterCriteriaType()}, ${getExtraFormInputType()}>";
  }

  // ***************************************************************************
  // ***************************************************************************

  void showFormErrorViewerDialog(BuildContext context) {
    if (formDataState != DataState.error) {
      return;
    }
    _showFormErrorViewerDialog(
      context: context,
      formErrorInfo: formErrorInfo!,
      formInitialDataReady: formInitialDataReady,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _triggerFilterCriteriaChanged() {
    _formPropsStructure._triggerFilterCriteriaChanged();
  }

  void _triggerItemIdChanged() {
    _formPropsStructure._triggerItemIdChanged();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormViewChangeAnnotation()
  Future<bool> _unitFormViewChanged({
    required _XFormModel xFormModel,
  }) async {
    __assertThisXFormModel(xFormModel);
    //
    await _startNewFormActivity(
      extraFormInput: null,
      activityType: FormActivityType.updateFromFormView,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelLoadFormAnnotation()
  Future<bool> _unitLoadForm({required _XFormModel thisXFormModel}) async {
    __assertThisXFormModel(thisXFormModel);
    //
    final bool forceReloadForm;
    switch (thisXFormModel.forceTypeForForm) {
      case _ForceType.force:
        forceReloadForm = true;
      case _ForceType.decidedAtRuntime:
        // forceReloadForm =
        //     formDataState != DataState.ready && hasActiveUIComponent();
        forceReloadForm = false;
    }
    //
    if (!forceReloadForm) {
      print("        ~~~~~~~> IGNORED --> form - [${block.name}]");
      if (formDataState != DataState.ready) {
        _clearDataWithDataState(formDataState: DataState.pending);
      }
      return true;
    }
    //
    EXTRA_FORM_INPUT? extraFormInput =
        thisXFormModel.extraFormInput as EXTRA_FORM_INPUT?;
    //
    return await _startNewFormActivity(
      extraFormInput: extraFormInput,
      activityType: FormActivityType.itemFirstLoad,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelEnterFormFieldsAnnotation()
  Future<bool> _unitQuickExtraFormInput({
    required _XFormModel thisXFormModel,
    required EXTRA_FORM_INPUT extraFormInput,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    await _startNewFormActivity(
      extraFormInput: extraFormInput,
      activityType: FormActivityType.autoEnterFormFields,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelSaveFormAnnotation()
  Future<bool> _unitSaveForm({required _XFormModel thisXFormModel}) async {
    FILTER_CRITERIA? blockCurrentFilterCriteria = block.filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      throw _FatalAppError(errorMessage: "FilterCriteria is null");
    }
    //
    // No need to check again?
    //
    Actionable<BlockFormSavingPrecheck> actionable = block.__canSaveForm(
      checkBusy: true,
      checkAllow: true,
      checkValidate: true,
    );
    if (!actionable.yes) {
      return false;
    }
    final Map<String, dynamic> formMapData =
        _formPropsStructure.currentFormData;
    //
    String calledMethodName = _formPropsStructure.isNew //
        ? 'callApiCreateItem'
        : 'callApiUpdateItem';
    //
    ApiResult<ITEM_DETAIL> result;
    bool saveError = false;
    final bool isNew = _formPropsStructure.isNew;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        ownerClassInstance: this,
        methodName: calledMethodName,
        parameters: {
          "formMapData": formMapData,
        },
        navigate: null,
      );
      //
      block._refreshSavingState(isSaving: true);
      Object? parentBlockItem = block.parent?.currentItem;
      //
      result = isNew
          ? await callApiCreateItem(
              filterCriteria: blockCurrentFilterCriteria,
              parentBlockItem: parentBlockItem,
              formMapData: formMapData,
            )
          : await callApiUpdateItem(
              filterCriteria: blockCurrentFilterCriteria,
              parentBlockItem: parentBlockItem,
              formMapData: formMapData,
            );
    } catch (e, stackTrace) {
      saveError = true;
      //
      _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    } finally {
      block._refreshSavingState(isSaving: false);
    }
    //
    try {
      return await block._processSaveActionRestResult(
        thisXBlock: thisXFormModel.xBlock,
        isNew: isNew,
        calledMethodName: calledMethodName,
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __registerPropsStructure() {
    try {
      _formPropsStructure = registerPropsStructure();
      _formPropsStructure.formModel = this;
    } on _DuplicateFormPropError catch (e) {
      String message =
          "Duplicate prop '${e.propName}' in ${getClassName(this)}";
      throw _createFatalAppError(message);
    } catch (e, stackTrace) {
      print(stackTrace);
      String message = "Unknown Error $e in ${getClassName(this)}";
      throw _createFatalAppError(message);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @_ImportantMethodAnnotation()
  Future<bool> _startNewFormActivity({
    required EXTRA_FORM_INPUT? extraFormInput,
    required FormActivityType activityType,
  }) async {
    FILTER_CRITERIA? blockCurrentFilterCriteria = block.filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      throw AppError(errorMessage: "FilterCriteria is null");
    }
    __formActivityCount++;
    print(
        "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFormActivity, activityType: $activityType");
    if (activityType == FormActivityType.itemFirstLoad) {
      __loadCount++;
      _autovalidateMode = AutovalidateMode.disabled;
    } else {
      _autovalidateMode = _defaultAutovalidateMode;
    }
    //
    final ITEM_DETAIL? itemDetail = block.currentItemDetail;
    final FormMode currentFormMode;
    switch (activityType) {
      case FormActivityType.itemFirstLoad:
        currentFormMode = itemDetail == null //
            ? FormMode.creation
            : FormMode.edit;
        //
        _formPropsStructure._clearFormError();
        _formPropsStructure._setFormDataState(
          formDataState: DataState.pending,
          error: null,
        );
      case FormActivityType.updateFromFormView:
        currentFormMode = formMode;
      case FormActivityType.autoEnterFormFields:
        currentFormMode = formMode;
    }
    //
    _formPropsStructure._setFormMode(currentFormMode);
    final bool isNoneMode = currentFormMode == FormMode.none;
    final bool isCreationMode = currentFormMode == FormMode.creation;
    //
    if (activityType == FormActivityType.itemFirstLoad) {
      if (isNoneMode || isCreationMode) {
        _defaultValueInitiated = false;
      }
    }
    //
    final Map<String, dynamic> formKeyInstantValues =
        _formKey.currentState?.instantValue ?? {};
    //
    _formPropsStructure._initTemporaryForNewTransaction(
      activityType: activityType,
      // Data from FormView:
      formKeyInstantValues: formKeyInstantValues,
    );
    //
    // Get SimpleProp Value:
    //
    Map<String, dynamic> simplePropValue = {};
    if (activityType == FormActivityType.itemFirstLoad) {
      if (itemDetail != null) {
        try {
          simplePropValue = await getSimplePropValuesFromItemDetail(
            filterCriteria: blockCurrentFilterCriteria,
            itemDetail: itemDetail,
          );
          for (String propName in simplePropValue.keys) {
            // In (First load + itemDetail != null)
            _formPropsStructure._setTempSimplePropValue(
              propName: propName,
              value: simplePropValue[propName],
              setForInitial: true,
            );
          }
        } catch (e, stackTrace) {
          final formErrorInfo = FormErrorInfo(
            activityType: activityType,
            propName: null,
            formErrorMethod: FormErrorMethod.getSimplePropValuesFromItemDetail,
            error: e,
            errorStackTrace: stackTrace,
          );
          _formPropsStructure._setFormError(formErrorInfo);
          //
          _handleError(
            shelf: shelf,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
          );
          //
          __endFormActivityWithDataState(
            formDataState: DataState.error,
            activityType: activityType,
            error: e,
          );
          return false;
        }
      }
      // itemDetail == null
      else {
        Map<String, dynamic> simplePropValueDefault = {};
        Map<String, dynamic> simplePropValueExtra = {};
        if (!_defaultValueInitiated) {
          try {
            simplePropValueDefault = await specifyDefaultSimplePropValues(
                  filterCriteria: blockCurrentFilterCriteria,
                ) ??
                {};
            //
            for (String propName in simplePropValueDefault.keys) {
              // In (Item First Load + itemDetail == null + !_defaultValueInitiated)
              _formPropsStructure._setTempSimplePropValue(
                propName: propName,
                value: simplePropValueDefault[propName],
                setForInitial: true,
              );
            }
          } catch (e, stackTrace) {
            final formErrorInfo = FormErrorInfo(
              activityType: activityType,
              propName: null,
              formErrorMethod: FormErrorMethod.specifyDefaultSimplePropValues,
              error: e,
              errorStackTrace: stackTrace,
            );
            _formPropsStructure._setFormError(formErrorInfo);
            //
            _handleError(
              shelf: shelf,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
            );
            //
            __endFormActivityWithDataState(
              formDataState: DataState.error,
              activityType: activityType,
              error: e,
            );
            return false;
          }
        }
        //
        if (extraFormInput != null) {
          try {
            simplePropValueExtra = getSimplePropValuesFromExtraFormInput(
                  extraFormInput: extraFormInput,
                ) ??
                {};
            //
            for (String propName in simplePropValueExtra.keys) {
              // In (ItemFirstLoad + extraFormInput != null)
              _formPropsStructure._setTempSimplePropValue(
                propName: propName,
                value: simplePropValueExtra[propName],
                setForInitial: true,
              );
            }
          } catch (e, stackTrace) {
            final formErrorInfo = FormErrorInfo(
              activityType: activityType,
              propName: null,
              formErrorMethod:
                  FormErrorMethod.getSimplePropValuesFromExtraFormInput,
              error: e,
              errorStackTrace: stackTrace,
            );
            _formPropsStructure._setFormError(formErrorInfo);
            //
            _handleError(
              shelf: shelf,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
            );
            //
            __endFormActivityWithDataState(
              formDataState: DataState.error,
              error: e,
              activityType: activityType,
            );
            return false;
          }
        }
      }
    }
    //
    // Load MultiOptProp Data:
    //
    try {
      for (MultiOptProp multiOptProp in _formPropsStructure._rootOptProps) {
        //
        // Load OptProp Data and set default and selected.
        //
        // May throw ApiError or _FormTempError.
        //
        await _loadMultiOptPropDataCascade(
          blockCurrentFilterCriteria: blockCurrentFilterCriteria,
          extraFormInput: extraFormInput,
          parentMultiOptPropValue: null,
          parentValueIsInitialValue: true,
          multiOptProp: multiOptProp,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      final FormErrorInfo formErrorInfo;
      if (e is _FormTempError) {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: e.propName,
          formErrorMethod: e.formErrorMethod,
          error: e.error,
          errorStackTrace: e.stackTrace,
        );
        _formPropsStructure._setFormError(formErrorInfo);
      } else {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: null,
          formErrorMethod: FormErrorMethod.unknown,
          error: e,
          errorStackTrace: stackTrace,
        );
        _formPropsStructure._setFormError(formErrorInfo);
      }
      //
      _handleError(
        shelf: shelf,
        methodName: formErrorInfo.methodName,
        error: formErrorInfo.error,
        stackTrace: formErrorInfo.errorStackTrace,
        showSnackBar: true,
      );
      //
      __endFormActivityWithDataState(
        formDataState: DataState.error,
        activityType: activityType,
        error: e,
      );
      return false;
    }
    //
    if (activityType == FormActivityType.autoEnterFormFields) {
      if (extraFormInput != null) {
        try {
          Map<String, dynamic> simplePropValueExtra =
              getSimplePropValuesFromExtraFormInput(
                    extraFormInput: extraFormInput,
                  ) ??
                  {};
          //
          for (String propName in simplePropValueExtra.keys) {
            // In (autoEnterFormFields + extraFormInput != null)
            _formPropsStructure._setTempSimplePropValue(
              propName: propName,
              value: simplePropValueExtra[propName],
              setForInitial: false,
            );
          }
        } catch (e, stackTrace) {
          final formErrorInfo = FormErrorInfo(
            activityType: activityType,
            propName: null,
            formErrorMethod:
                FormErrorMethod.getSimplePropValuesFromExtraFormInput,
            error: e,
            errorStackTrace: stackTrace,
          );
          _formPropsStructure._setFormError(formErrorInfo);
          //
          _handleError(
            shelf: shelf,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
          );
          //
          __endFormActivityWithDataState(
            formDataState: DataState.error,
            activityType: activityType,
            error: e,
          );
          return false;
        }
      }
    }
    //
    return __endFormActivityWithDataState(
      formDataState: DataState.ready,
      activityType: activityType,
      error: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __endFormActivityWithDataState({
    required DataState formDataState,
    required FormActivityType activityType,
    required dynamic error,
  }) {
    try {
      //
      // Update Real FromData from Temporary FormData:
      //
      _formPropsStructure._updateTempToReal();
      //
      if (activityType == FormActivityType.itemFirstLoad) {
        _formPropsStructure._setInitialFormDataForItemFirstLoad();
      }
      //
      // IMPORTANT: (Called on Field.onChanged).
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      _defaultValueInitiated = true;
      _formPropsStructure._setFormDataState(
        formDataState: formDataState,
        error: error,
      );
      //
      if (activityType == FormActivityType.itemFirstLoad) {
        if (formDataState == DataState.ready) {
          _formPropsStructure._formInitialDataReady = true;
        }
      }
      // Form Disabled:
      if (!_formPropsStructure._formInitialDataReady) {
        // Clear form validation error
      }
      // Form Initial Data Ready
      else {
        // Validate Form
        if (activityType == FormActivityType.itemFirstLoad) {
          if (formMode == FormMode.edit && _formKey.currentState != null) {
            if (_formPropsStructure._formInitialDataReady) {
              _formKey.currentState!.validate(focusOnInvalid: false);
            }
          }
        }
      }
      //
      return true;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "__applyWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      _formPropsStructure._setFormDataState(
        formDataState: DataState.error,
        error: e,
      );
      return false;
    } finally {
      _formPropsStructure.__isTempMode = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printStructureAndTempData(String prefix) {
    _formPropsStructure._printTemporaryInfo(prefix);
    print("instantData: ${_formKey.currentState?.instantValue}\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  // TestCase [16a]-changeSupplierType.
  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    try {
      _formKey.currentState?.patchValue(newCurrentValue);
    } finally {
      //
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptPropDataCascade({
    required FILTER_CRITERIA blockCurrentFilterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required Object? parentMultiOptPropValue,
    required MultiOptProp multiOptProp,
    required bool parentValueIsInitialValue,
    required Map<String, dynamic> formKeyInstantValues,
    required FormActivityType activityType,
  }) async {
    final String multiOptPropName = multiOptProp.propName;

    // Get current OptProp data:
    XData? tempMultiOptPropXData =
        _formPropsStructure._getTempMultiOptPropXData(
      propName: multiOptPropName,
    );

    final dynamic tempInitialMultiOptValue = _formPropsStructure
        ._getTempInitialPropValue(propName: multiOptPropName);
    final dynamic tempCurrentMultiOptValue = _formPropsStructure
        ._getTempCurrentPropValue(propName: multiOptPropName);

    //
    dynamic newSelectedValue = _formPropsStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );
    if (activityType == FormActivityType.updateFromFormView) {
      if (formKeyInstantValues.containsKey(multiOptPropName)) {
        newSelectedValue = formKeyInstantValues[multiOptPropName];
      }
    }
    //
    final bool valueChanged;
    if (tempMultiOptPropXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempMultiOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    //
    final bool multiOptValueIsInitialValue;
    if (tempMultiOptPropXData == null) {
      multiOptValueIsInitialValue = false;
    } else {
      multiOptValueIsInitialValue = tempMultiOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempInitialMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    //
    multiOptProp._tempCurrentValue = newSelectedValue;
    //
    if (valueChanged) {
      _formPropsStructure._updateChildrenMultiOptValueToNullCascade(
        multiOptProp: multiOptProp,
      );
    }
    //
    if (tempMultiOptPropXData == null) {
      _formPropsStructure._setTempMultiOptPropXData(
        multiOptPropName: multiOptPropName,
        multiOptPropXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updatePropsTempValues({multiOptPropName: null});
    }
    //
    bool forceReload =
        multiOptProp.parent == null && multiOptProp._markToReload;
    //
    // Load OptProp data from Rest API.
    // May throw ApiError.
    //
    if (tempMultiOptPropXData == null || forceReload) {
      // Always increase "__loadCount" value regardless of error.
      multiOptProp._loadCount++;
      Object? parentBlockItem = this.block.parent?.currentItem;
      //
      try {
        // May throw AppError, ApiError or others.
        tempMultiOptPropXData = await callApiLoadMultiOptPropXData(
          parentBlockCurrentItem: parentBlockItem,
          filterCriteria: blockCurrentFilterCriteria,
          extraFormInput: extraFormInput,
          parentMultiOptPropValue: parentMultiOptPropValue,
          multiOptPropName: multiOptPropName,
        );
      } catch (e, stackTrace) {
        throw _FormTempError(
          propName: multiOptPropName,
          formErrorMethod: FormErrorMethod.callApiLoadMultiOptPropXData,
          error: e, // May be AppError, ApiError or others.
          stackTrace: stackTrace,
        );
      }
      //
      multiOptProp._markToReload = false;
      multiOptProp._tempCurrentXData = tempMultiOptPropXData;
    }
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    ValueWrap? initialValueWrap;
    final ITEM_DETAIL? currentItemDetail = block.currentItemDetail;
    //
    if (tempMultiOptPropXData != null) {
      // Item First Load:
      if (activityType == FormActivityType.itemFirstLoad) {
        if (currentItemDetail == null) {
          if (extraFormInput != null) {
            // May throw _FormTempError.
            initialValueWrap = __getMultiOptPropValueFromExtraFormInput(
              extraFormInput: extraFormInput,
              multiOptPropXData: tempMultiOptPropXData,
              multiOptPropName: multiOptPropName,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
            // TODO-XXX Test Case.
            if (initialValueWrap == null) {
              if (!_defaultValueInitiated) {
                // May throw _FormTempError.
                initialValueWrap = __specifyDefaultMultiOptPropValue(
                  multiOptPropName: multiOptPropName,
                  multiOptPropXData: tempMultiOptPropXData,
                  parentMultiOptPropValue: parentMultiOptPropValue,
                );
              }
            }
          } else {
            if (!_defaultValueInitiated) {
              // May throw _FormTempError.
              initialValueWrap = __specifyDefaultMultiOptPropValue(
                multiOptPropName: multiOptPropName,
                multiOptPropXData: tempMultiOptPropXData,
                parentMultiOptPropValue: parentMultiOptPropValue,
              );
            }
          }
        }
        // currentItemDetail != null
        else {
          // May throw _FormTempError.
          initialValueWrap = __getMultiOptPropValueFromItemDetail(
            itemDetail: currentItemDetail,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
        }
      }
      // Auto Enter Form Fields:
      else if (activityType == FormActivityType.autoEnterFormFields) {
        if (extraFormInput != null) {
          // May throw _FormTempError.
          initialValueWrap = __getMultiOptPropValueFromExtraFormInput(
            extraFormInput: extraFormInput,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _formPropsStructure._getTempCurrentPropValue(
        propName: multiOptPropName,
      );
      //
      if (tempCurrentValue != null) {
        if (tempCurrentValue is List) {
          currentSelectedItems =
              tempCurrentValue.isEmpty ? null : tempCurrentValue;
        } else {
          currentSelectedItems = [tempCurrentValue];
        }
      }
      if (currentSelectedItems != null) {
        currentSelectedItems =
            tempMultiOptPropXData._findInternalItemsByDynamics(
          dynamicValues: currentSelectedItems,
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
        );
      }
      // Candidate Selected Items:
      candidateSelectedItems = initialValueWrap?.values;

      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    }
    // optPropData == null
    else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }
    //
    _formPropsStructure._setTempMultiOptPropXData(
      multiOptPropName: multiOptPropName,
      multiOptPropXData: tempMultiOptPropXData,
    );
    //
    final dynamic initialValue;
    if (activityType == FormActivityType.itemFirstLoad) {
      initialValue = initialValueWrap?.values;
    } else {
      initialValue = _formPropsStructure._getInitialPropValue(
        propName: multiOptPropName,
      );
    }
    //
    if (activityType == FormActivityType.itemFirstLoad ||
        parentValueIsInitialValue) {
      tempMultiOptPropXData?._addInitialValueIfNotFound(
        initialValue: initialValue,
        removeCurrentNotFoundItems: true,
      );
    }
    // TODO: Dangerous, check not null:
    candidateSelectedItems =
        tempMultiOptPropXData?._findInternalItemsByDynamics(
              dynamicValues: candidateSelectedItems,
              //
              // IMPORTANT: Add not found item to internal list.
              //
              addToInternalIfNotFound: true,
              removeCurrentNotFoundItems: false,
            ) ??
            [];
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (multiOptProp.singleSelection) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _formPropsStructure
            ._updatePropsTempValues({multiOptPropName: candidateSelectedItem});
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _formPropsStructure
            ._updatePropsTempValues({multiOptPropName: candidateSelectedItems});
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updatePropsTempValues({multiOptPropName: null});
    }
    //
    Object? tempSelectedPropValue =
        _formPropsStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );

    if (tempSelectedPropValue != null) {
      for (MultiOptProp child in multiOptProp._children) {
        await _loadMultiOptPropDataCascade(
          blockCurrentFilterCriteria: blockCurrentFilterCriteria,
          extraFormInput: extraFormInput,
          parentMultiOptPropValue: tempSelectedPropValue,
          parentValueIsInitialValue: multiOptValueIsInitialValue,
          multiOptProp: child,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Used for FormView.
  ///
  Map<String, dynamic> _initialValuesForFormView() {
    return _formPropsStructure.currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getInitialPropValue(String propName) {
    return _formPropsStructure._getInitialPropValue(propName: propName);
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Add test case:
  @Deprecated("Xem lai, co can xoa di khong?")
  void setFormInstantValue(String propertyName, dynamic value) {
    _formKey.currentState?.patchValue({propertyName: value});
    _formPropsStructure._setCurrentPropValue(
      propName: propertyName,
      value: value,
    );
    this.updateAllUIComponents();
  }

  dynamic getPropValue(String propName) {
    return _formPropsStructure._getCurrentPropValue(
      propName: propName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  int getMultiOptPropLoadCount(String multiOptPropName) {
    return _formPropsStructure._getMultiOptPropLoadCount(
      propName: multiOptPropName,
    );
  }

  XData? getMultiOptPropXData(String multiOptPropName) {
    return _formPropsStructure._getCurrentMultiOptPropXData(
      propName: multiOptPropName,
    );
  }

  dynamic getMultiOptPropData(String multiOptPropName) {
    return _formPropsStructure._getCurrentMultiOptPropData(
      propName: multiOptPropName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  ValueWrap? __specifyDefaultMultiOptPropValue({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      ValueWrap? valueWrap = specifyDefaultMultiOptPropValue(
        multiOptPropXData: multiOptPropXData,
        multiOptPropName: multiOptPropName,
        parentMultiOptPropValue: parentMultiOptPropValue,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "specifyDefaultMultiOptPropValue",
          multiOptPropName: multiOptPropName,
        );
        return null;
      }
      List? value = valueWrap?.values ?? [];
      return ValueWrap.multi(
        multiOptPropXData._findInternalItemsByDynamics(
          dynamicValues: value,
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw _FormTempError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.specifyDefaultMultiOptPropValue,
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
    MultiOptProp? multiOptProp =
        _formPropsStructure._getMultiOptProp(multiOptPropName);
    if (multiOptProp == null) {
      throw "The '$multiOptPropName' is not $MultiOptProp";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $ValueWrap for the multiOptPropName '$multiOptPropName'. ";
    if (multiOptProp.singleSelection) {
      message += "$ValueWrap.single(null) or $ValueWrap.single(value). ";
    } else {
      message += "$ValueWrap.multi([null]) or $ValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptProp. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  ValueWrap? __getMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required ITEM_DETAIL itemDetail,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      ValueWrap? valueWrap = getMultiOptPropValueFromItemDetail(
        multiOptPropName: multiOptPropName,
        multiOptPropXData: multiOptPropXData,
        itemDetail: itemDetail,
        parentMultiOptPropValue: parentMultiOptPropValue,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "getMultiOptPropValueFromItemDetail",
          multiOptPropName: multiOptPropName,
        );
      }
      return valueWrap;
    } catch (e, stackTrace) {
      throw _FormTempError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.getMultiOptPropValueFromItemDetail,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  ValueWrap? __getMultiOptPropValueFromExtraFormInput({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required EXTRA_FORM_INPUT extraFormInput,
    required Object? parentMultiOptPropValue,
  }) {
    if (extraFormInput is EmptyExtraFormInput) {
      return null;
    }
    try {
      ValueWrap? valueWrap = getMultiOptPropValueFromExtraFormInput(
        extraFormInput: extraFormInput,
        multiOptPropXData: multiOptPropXData,
        multiOptPropName: multiOptPropName,
        parentMultiOptPropValue: parentMultiOptPropValue,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "getMultiOptPropValueFromExtraFormInput",
          multiOptPropName: multiOptPropName,
        );
      }
      List? value = valueWrap?.values ?? [];
      return ValueWrap.multi(
        multiOptPropXData._findInternalItemsByDynamics(
          dynamicValues: value,
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw _FormTempError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.getMultiOptPropValueFromExtraFormInput,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isNew {
    return _formPropsStructure.isNew;
  }

  Map<String, dynamic> get initialFormData {
    return _formPropsStructure.initialFormData;
  }

  Map<String, dynamic> get currentFormData {
    return _formPropsStructure.currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearDataWithDataState({required DataState formDataState}) {
    try {
      _formPropsStructure._clearFormDataWithState(
        formDataState: formDataState,
      );
      //
      this.__clearFormKey();
      //
      // updateAllUIComponents(); // TODO: Xu ly loi?
      block.updateControlBarWidgets();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_clearDataWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearFormKey() {
    final Map<String, dynamic> instantValues =
        this._formKey.currentState?.instantValue ?? {};
    //
    final Map<String, dynamic> newFormData = {...instantValues}
      ..updateAll((k, v) => null);
    this._formKey.currentState?.patchValue(newFormData);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFormViewBuildingState({
    required _RefreshableWidgetState widgetState,
    required bool isBuilding,
  }) {
    _formWidgetStates.update(
      widgetState,
      (xState) => xState..isBuilding = isBuilding,
      ifAbsent: () => _XState()..isBuilding = isBuilding,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addFormWidgetState({
    required _RefreshableWidgetState widgetState,
    required final bool isShowing,
  }) {
    bool isShowingOLD = _formWidgetStates[widgetState]?.isShowing ?? false;
    _formWidgetStates.update(
      widgetState,
      (xState) => xState..isShowing = isShowing,
      ifAbsent: () => _XState()..isShowing = isShowing,
    );
    if (!isShowingOLD && isShowing) {
      block.shelf._startLoadDataForLazyUIComponentsIfNeed();
    }
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeFormWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _formWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents({bool force = false}) {
    __updateFormWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Call this method to refresh Widgets..
  ///
  void __updateFormWidgets({bool force = false}) {
    List<_RefreshableWidgetState> list = _getMountedFormWidgetStates();
    for (_RefreshableWidgetState formWidgetState in list) {
      if (formWidgetState.mounted) {
        formWidgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<_RefreshableWidgetState> _getMountedFormWidgetStates() {
    List<_RefreshableWidgetState> ret = [];
    for (_RefreshableWidgetState widgetState in [..._formWidgetStates.keys]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _formWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    for (State formWidgetState in _formWidgetStates.keys) {
      bool visible = _formWidgetStates[formWidgetState]?.isShowing ?? false;
      if (visible && formWidgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return _formPropsStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    Actionable actionable = block._isEnableFormToModify();
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  void resetForm() {
    Actionable canReset = block.canResetForm();
    if (canReset.no) {
      return;
    }
    try {
      _changeEventLocked = true;
      //
      // Reset FormData:
      //
      _formPropsStructure._resetFormData();
      //
      // Patch _formKey:
      //
      Map<String, dynamic> initData = {..._formPropsStructure.initialFormData};
      for (String key in _formKey.currentState?.instantValue.keys ?? []) {
        if (!initData.containsKey(key)) {
          initData[key] = null;
        }
      }
      _formKey.currentState?.patchValue(initData);
      //
      shelf.updateAllUIComponents();
    } finally {
      _changeEventLocked = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  @_ImportantMethodAnnotation()
  @_FormViewChangeAnnotation()
  Future<void> _onChangeFromFormView() async {
    print("#~~~~~~~~~~~~~~~> _onChangeFromFormView");
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    _XFormModel xFormModel = xBlock.xFormModel!;
    _FormViewChangeTaskUnit taskUnit =
        _FormViewChangeTaskUnit(xFormModel: xFormModel);
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    await FlutterArtist.executor._executeTaskUnitQueue(showOverlay: false);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return _formWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFormView() {
    _formPropsStructure._justInitialized = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Private method. Only for use in this class.
  // bool __checkWithFormValidationBeforeSave() {
  //   Actionable actionable = block.canSaveForm();
  //   if (!actionable.yes) {
  //     return false;
  //   }
  //   return _formKey.currentState?.validate() ?? false;
  // }

  // ***************************************************************************
  // ***************************************************************************

  Actionable<EnterFormFieldsState> __canEnterFormFields({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable.no(eCode: EnterFormFieldsState.busy);
    }
    if (formMode == FormMode.none) {
      return Actionable.no(eCode: EnterFormFieldsState.formInNoneMode);
    }
    if (formDataState == DataState.error) {
      return Actionable.no(eCode: EnterFormFieldsState.formInErrorState);
    }
    return Actionable.yes();
  }

  bool __checkBeforeEnterFormFields({
    required bool checkBusy,
    required bool addErrorLog,
    required bool showErrSnackBar,
  }) {
    Actionable createActionable = __canEnterFormFields(
      checkBusy: checkBusy,
    );
    if (!createActionable.yes) {
      if (addErrorLog) {
        _addErrorLogActionable(
          shelf: shelf,
          actionableFalse: createActionable,
          showErrSnackBar: showErrSnackBar,
        );
      }
      return false;
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Test Case: [26a]
  @_RootMethodAnnotation()
  @_FormModelEnterFormFieldsAnnotation()
  Future<bool> enterFormFields({
    required EXTRA_FORM_INPUT extraFormInput,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "enterFormFields",
      parameters: {"extraFormInput": extraFormInput},
      navigate: null,
    );
    //
    if (!__checkBeforeEnterFormFields(
      checkBusy: true,
      addErrorLog: true,
      showErrSnackBar: true,
    )) {
      return false;
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(this.block.name)!;
    _XFormModel xFormModel = xBlock.xFormModel!;
    _TaskUnit taskUnit = _FormModelAutoEnterFormFieldsTaskUnit(
      xFormModel: xFormModel,
      extraFormInput: extraFormInput,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_FormModelSaveFormAnnotation()
  Future<FormSaveResult> saveForm() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "saveForm",
      parameters: {},
      navigate: null,
    );
    //
    Actionable<BlockFormSavingPrecheck> actionable = block.__canSaveForm(
      checkBusy: true,
      checkAllow: true,
      checkValidate: true,
    );
    if (!actionable.yes) {
      _saveErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return FormSaveResult(precheck: actionable.eCode);
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(this.block.name)!;
    _XFormModel xFormModel = xBlock.xFormModel!;
    _TaskUnit taskUnit = _FormModelSaveFormTaskUnit(
      xFormModel: xFormModel,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return xFormModel._formSaveResult;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXFormModel(_XFormModel thisXFormModel) {
    if (!identical(thisXFormModel.formModel, this)) {
      String message =
          "Error Assets form model: ${thisXFormModel.formModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
