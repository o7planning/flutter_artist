part of '../flutter_artist.dart';

abstract class FormModel<
    ID extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> extends _XBase {
  QueryMode _queryMode = QueryMode.lazy;

  late QueryMode _tempQueryMode = _queryMode;

  int __loadCount = 0;

  int get loadCount => __loadCount;

  int __prepareFormMasterDataCount = 0;

  int get prepareFormMasterDataCount => __prepareFormMasterDataCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  String get id {
    return "block-form > ${shelf.name} > ${block.name}";
  }

  late final FormModelData data = FormModelData(formModel: this);

  FormMode get formMode => data.formMode;

  Shelf get shelf => block.shelf;

  late final Block<
      ID, //
      Object,
      ITEM_DETAIL,
      FilterInput,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  bool _initiated = false;

  bool _defaultValueInitiated = false;

  late final FormPropsStructure _formPropsStructure;

  DataState get formDataState => data._formDataState;

  QueryMode get queryMode => _queryMode;

  QueryMode get temporaryQueryMode => _tempQueryMode;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _defaultAutovalidateMode = AutovalidateMode.onUserInteraction;

  late AutovalidateMode autovalidateMode = _defaultAutovalidateMode;

  final Map<_RefreshableWidgetState, _XState> _formWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  FormModel() {
    __registerPropsStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitFormViewChanged({
    required _XFormModel xFormModel,
  }) async {
    __assertThisXFormModel(xFormModel);
    //
    // data._formDataState = DataState.pending.
    //
    await _startNewFormTransaction(
      extraFormInput: null,
      filterCriteria: block.data.filterCriteria,
      isItemFirstLoad: false,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitLoadForm({required _XFormModel thisXFormModel}) async {
    __assertThisXFormModel(thisXFormModel);
    //
    bool active = this.hasActiveUIComponent();
    bool forceForm = thisXFormModel.forceForm;
    //
    if (!forceForm) {
      if (!active) {
        if (this.formDataState == DataState.error ||
            this.formDataState == DataState.pending) {
          _clearWithDataState(formDataState: this.formDataState);
          return true;
        } else {
          return true;
        }
      } else {
        if (this.formDataState == DataState.error ||
            this.formDataState == DataState.pending) {
          forceForm = true;
        } else {
          return true;
        }
      }
    }
    //
    __loadCount++;
    //
    FILTER_CRITERIA? filterCriteria = this.block.data.filterCriteria;
    EXTRA_FORM_INPUT? extraFormInput =
        thisXFormModel.extraFormInput as EXTRA_FORM_INPUT?;
    //
    await _startNewFormTransaction(
      extraFormInput: extraFormInput,
      filterCriteria: filterCriteria,
      isItemFirstLoad: true,
    );
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitSaveForm({required _XFormModel thisXFormModel}) async {
    if (!__checkValidBeforeSave()) {
      return false;
    }
    Map<String, dynamic> formMapData = data.currentFormData;
    //
    String calledMethodName = data.isNew //
        ? 'callApiCreateItem'
        : 'callApiUpdateItem';
    //
    ApiResult<ITEM_DETAIL> result;
    bool saveError = false;
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
      //
      result = data.isNew
          ? await callApiCreateItem(formMapData: formMapData)
          : await callApiUpdateItem(formMapData: formMapData);
      //
      block._refreshSavingState(isSaving: false);
    } catch (e, stackTrace) {
      saveError = true;
      block._refreshSavingState(isSaving: false);
      //
      _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    try {
      return await block._processSaveActionRestResult(
        thisXBlock: thisXFormModel.xBlock,
        calledMethodName: calledMethodName,
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '_processSaveActionRestResult',
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

  ///
  /// ```dart
  /// PropsStructure registerPropsStructure() {
  ///   return PropsStructure(
  ///     optProps: [
  ///       OptProp(
  ///         propName: "company",
  ///         children: [
  ///           OptProp(
  ///              propName: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  FormPropsStructure? registerPropsStructure();

  // ***************************************************************************
  // ***************************************************************************

  void __registerPropsStructure() {
    _formPropsStructure = registerPropsStructure() ??
        FormPropsStructure(
          allPropNames: [],
          optProps: [],
        );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @ImportantMethodAnnotation()
  Future<bool> _startNewFormTransaction({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required bool isItemFirstLoad,
  }) async {
    print(
        "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFormTransaction, isItemFirstLoad: $isItemFirstLoad");
    print("@ current: ${data._currentFormData}");
    final ITEM_DETAIL? itemDetail = block.data.currentItemDetail;
    final FormMode currentFormMode = data._formDataState == DataState.none
        ? FormMode.none
        : itemDetail == null
            ? FormMode.creation
            : FormMode.edit;
    data._formMode = currentFormMode;
    bool isNoneMode = currentFormMode == FormMode.none;
    bool isCreationMode = currentFormMode == FormMode.creation;
    //
    try {
      // All values including hidden values (not on the user interface).
      Map<String, dynamic> allNewValue = {};
      //
      // The First Load (Not from FormView)
      //
      if (isItemFirstLoad) {
        if (isNoneMode || isCreationMode) {
          _defaultValueInitiated = false;
          allNewValue.addAll({});
        } else {
          allNewValue.addAll({});
        }
        //
        if (!_initiated && _formKey.currentState != null) {
          _initiated = true;
          data._initialFormData2(allNewValue);
        }
      }
      //
      // Update from FormView:
      //
      else {
        allNewValue.addAll(data._currentFormData);
        // Update values from view (On the user Interface).
        allNewValue.addAll(_formKey.currentState?.instantValue ?? {});
      }
      //
      _formPropsStructure._initTemporaryForNewTransaction(
        currentFormData: allNewValue,
      );
      _formPropsStructure._printTemporaryInfo("@1");
      //
      for (OptProp optProp in _formPropsStructure._rootOptProps) {
        //
        // Load OptProp Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadOptPropDataCascade(
          extraFormInput: extraFormInput,
          parentOptPropValue: null,
          optProp: optProp,
        );
      }
      _formPropsStructure._printTemporaryInfo("@2");
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiLoadOptPropData",
        error: "Error callApiLoadOptPropData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      __applyWithDataState(formDataState: DataState.error);
      return false;
    }
    //
    _printStructureAndTempData("@3");
    Map<String, dynamic> simplePropValue = {};
    if (isItemFirstLoad) {
      if (itemDetail != null) {
        try {
          simplePropValue = getSimplePropValuesFromItemDetail(
            itemDetail: itemDetail,
          );
          for (String propName in simplePropValue.keys) {
            _formPropsStructure._setTempSimplePropData(
              propName: propName,
              value: simplePropValue[propName],
            );
          }
        } catch (e, stackTrace) {
          _handleError(
            shelf: shelf,
            methodName: "getSimplePropValuesFromItemDetail",
            error: "Error getSimplePropValuesFromItemDetail: $e",
            stackTrace: stackTrace,
            showSnackBar: true,
          );
          //
          __applyWithDataState(formDataState: DataState.error);
          return false;
        }
      }
      // itemDetail == null
      else {
        Map<String, dynamic> simplePropValueDefault = {};
        Map<String, dynamic> simplePropValueExtra = {};
        if (!_defaultValueInitiated) {
          try {
            simplePropValueDefault = specifyDefaultSimplePropValues() ?? {};
            for (String propName in simplePropValueDefault.keys) {
              _formPropsStructure._setTempSimplePropData(
                propName: propName,
                value: simplePropValueDefault[propName],
              );
            }
          } catch (e, stackTrace) {
            _handleError(
              shelf: shelf,
              methodName: "specifyDefaultSimplePropValues",
              error: "Error specifyDefaultSimplePropValues: $e",
              stackTrace: stackTrace,
              showSnackBar: true,
            );
            //
            __applyWithDataState(formDataState: DataState.error);
            return false;
          }
        }
        if (extraFormInput != null) {
          try {
            simplePropValueExtra = getSimplePropValuesFromExtraFormInput(
                  extraFormInput: extraFormInput,
                ) ??
                {};
            //
            for (String propName in simplePropValueExtra.keys) {
              _formPropsStructure._setTempSimplePropData(
                propName: propName,
                value: simplePropValueExtra[propName],
              );
            }
          } catch (e, stackTrace) {
            _handleError(
              shelf: shelf,
              methodName: "getSimplePropValuesFromItemDetail",
              error: "Error getSimplePropValuesFromItemDetail: $e",
              stackTrace: stackTrace,
              showSnackBar: true,
            );
            //
            __applyWithDataState(formDataState: DataState.error);
            return false;
          }
        }
      }
    }
    _printStructureAndTempData("@4");
    return __applyWithDataState(formDataState: DataState.ready);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __applyWithDataState({required DataState formDataState}) {
    print("@@@ __applyWithDataState: $formDataState");
    try {
      //
      // Update Real FromData from Temporary FormData:
      //
      this.data._currentFormData
        ..updateAll((k, v) => null)
        ..addAll(_formPropsStructure._tempCurrentFormData);

      //
      // UPDATE OPT-DATA:
      //  - optProp._xOptionedData = optProp._tempXOptionedData;
      //
      this._formPropsStructure._applyAllTempDataToReal();
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(newCurrentValue: data._currentFormData);
      //
      _defaultValueInitiated = true;
      data._formDataState = formDataState;
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
      // IMPORTANT: Restore OLD State:
      // Note [_formKeyPatchValueSilently] NOT WORK!.
      //
      _formKeyPatchValueSilently(newCurrentValue: data._currentFormData);
      //
      data._formDataState = DataState.error;
      return false;
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

  ///
  /// Note: This method Patch value for [_formKey.currentState] silently,
  /// it will not call [onChange] event of Fields.
  ///
  /// If call [_formKey.currentState?.patchValue] method, it will call [onChange] event.
  ///
  /// TODO: Need to catch error??
  ///
  void _formKeyPatchValueSilently({
    required Map<String, dynamic> newCurrentValue,
  }) {
    try {
      for (String key in newCurrentValue.keys) {
        dynamic value = newCurrentValue[key];
        //
        //
        // IMPORTANT:
        //  Update FormBuilder View State:
        //
        _formKey.currentState?.fields[key]?.setValue(
          value,
          //
          // populateForm: true ---> _formKey.currentState?setInternalFieldValue(key,value)
          // populateForm: false ---> [Do nothing]
          //
          populateForm: true, // [Update FormBuilder Model]
        );
      }
    } finally {
      //
    }
  }

  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    try {
      _formKey.currentState?.patchValue(newCurrentValue);
    } finally {
      //
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadOptPropDataCascade({
    required EXTRA_FORM_INPUT? extraFormInput,
    required Object? parentOptPropValue, // May be new selected parent value.
    required OptProp optProp,
  }) async {
    final String optPropName = optProp.propName;

    final OptProp? optPropParent = optProp?.parent;

    // Get current OptProp data:
    XOptionedData? optPropData =
        _formPropsStructure._getOptPropData(optPropName);

    if (optPropParent != null) {
      XOptionedData? tempXOptionedParent =
          _formPropsStructure._getTempOptPropData(
        optPropParent.propName,
      );
      //
      if (tempXOptionedParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptPropValueOLD =
            data._currentFormData[optPropParent.propName];

        // Parent Value change?
        bool isSame = tempXOptionedParent.isSameItemOrItemList(
          itemOrItemList1: parentOptPropValueOLD,
          itemOrItemList2: parentOptPropValue,
        );
        if (!isSame) {
          optPropData = null;
        }
      } else {
        optPropData = null;
      }
    }

    //
    // Load OptProp data from Rest API.
    // May throw ApiError.
    //
    optPropData ??= await callApiLoadOptPropData(
      extraFormInput: extraFormInput,
      parentOptPropValue: parentOptPropValue,
      optPropName: optPropName,
    );
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    PropValue? selectedValueWrap;
    final ITEM_DETAIL? currentItemDetail = block.data.currentItemDetail;
    if (optPropData != null) {
      if (currentItemDetail == null) {
        if (extraFormInput != null) {
          selectedValueWrap = _getOptPropValueFromExtraFormInput(
            extraFormInput: extraFormInput,
            optPropData: optPropData,
            optPropName: optPropName,
          );
        } else {
          if (!_defaultValueInitiated) {
            selectedValueWrap = __specifyDefaultOptPropValue(
              optPropData: optPropData,
              optPropName: optPropName,
            );
          }
        }
      }
      // currentItemDetail != null
      else {
        selectedValueWrap = getOptPropValueFromItemDetail(
          itemDetail: currentItemDetail,
          optPropData: optPropData,
          optPropName: optPropName,
        );
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _formPropsStructure._getTempCurrentPropValue(
        propName: optPropName,
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
        currentSelectedItems = optPropData.findInternalItemsByDynamics(
          dynamicValues: currentSelectedItems,
          addToInternalIfNotFound: true,
        );
      }
      // Candidate Selected Items:
      candidateSelectedItems = selectedValueWrap?.value;

      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    } else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }
    //
    _formPropsStructure._setTempOptPropData(
      propName: optPropName,
      optionedData: optPropData,
    );
    // TODO: Dangerous check not null:
    candidateSelectedItems = optPropData!.findInternalItemsByDynamics(
      dynamicValues: candidateSelectedItems,
      addToInternalIfNotFound: true,
    );
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (optProp.singleSelection) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _formPropsStructure
            ._updateTempData({optPropName: candidateSelectedItem});
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _formPropsStructure
            ._updateTempData({optPropName: candidateSelectedItems});
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updateTempData({optPropName: null});
    }

    //
    Object? tempSelectedPropValue =
        this._formPropsStructure._getTempCurrentPropValue(
              propName: optPropName,
            );

    if (tempSelectedPropValue != null) {
      for (OptProp child in optProp.children) {
        await _loadOptPropDataCascade(
          extraFormInput: extraFormInput,
          parentOptPropValue: tempSelectedPropValue,
          optProp: child,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XOptionedData? getOptPropXData(String propName) {
    return _formPropsStructure._getOptPropData(propName);
  }

  dynamic getOptPropData(String propName) {
    XOptionedData? optPropData = getOptPropXData(propName);
    dynamic data = optPropData?.data;
    if (data != null) {
      return data;
    } else {
      return data;
      // OptPropType? type = getOptPropType(propName);
      // switch (type) {
      //   case null:
      //     return data;
      //   case OptPropType.list:
      //     return [];
      //   case OptPropType.custom:
      //     return data;
      // }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  PropValue? __specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String optPropName,
  }) {
    PropValue? wrap = specifyDefaultOptPropValue(
      optPropData: optPropData,
      optPropName: optPropName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.value;
    return PropValue(
      optPropData.findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: true,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  PropValue? _getOptPropValueFromExtraFormInput({
    required EXTRA_FORM_INPUT extraFormInput,
    required XOptionedData optPropData,
    required String optPropName,
  }) {
    PropValue? wrap = getOptPropValueFromExtraFormInput(
      extraFormInput: extraFormInput,
      optPropData: optPropData,
      optPropName: optPropName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.value;
    return PropValue(
      optPropData.findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: true,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic>? getSimplePropValuesFromExtraFormInput({
    required EXTRA_FORM_INPUT extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> getSimplePropValuesFromItemDetail({
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic>? specifyDefaultSimplePropValues();

  // ***************************************************************************
  // ***************************************************************************

  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String optPropName,
  });

  // ***************************************************************************
  // ***************************************************************************

  PropValue? getOptPropValueFromItemDetail({
    required ITEM_DETAIL itemDetail,
    required XOptionedData optPropData,
    required String optPropName,
  });

  // ***************************************************************************
  // ***************************************************************************

  PropValue? getOptPropValueFromExtraFormInput({
    required EXTRA_FORM_INPUT extraFormInput,
    required XOptionedData optPropData,
    required String optPropName,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XOptionedData?> callApiLoadOptPropData({
    required EXTRA_FORM_INPUT? extraFormInput,
    required Object? parentOptPropValue,
    required String optPropName,
  });

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState formDataState}) {
    try {
      this.data._clearWithDataState(
            formDataState: formDataState,
          );
      //
      this.__clearFormKey();
      //
      updateAllUIComponents(); // TODO: Xu ly loi?
      block.updateControlBarWidgets();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_clearWithDataState",
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
      block.shelf._startNewLazyQueryTransactionIfNeed();
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
    return data._isDirty();
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
    Map<String, dynamic> initData = {...data._initialFormData};
    for (String key in _formKey.currentState?.instantValue.keys ?? []) {
      if (!initData.containsKey(key)) {
        initData[key] = null;
      }
    }
    _formKey.currentState?.patchValue(initData);
    //
    shelf.updateAllUIComponents();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  Future<void> _onChangeFromFormView() async {
    // if (_formKey.currentState?.instantValue != null) {
    //   data._currentFormData.addAll(_formKey.currentState!.instantValue);
    //   if (data._justInitialized) {
    //     data._initialFormData.addAll(_formKey.currentState!.instantValue);
    //   }
    // }
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
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return _formWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFormView() {
    data._justInitialized = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Change name!
  // Do not call this method in library.
  Map<String, dynamic> initFormValue() {
    return data._currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getFormInstantValue(String propertyName) {
    return data._currentFormData[propertyName];
  }

  // ***************************************************************************
  // ***************************************************************************

  void setFormInstantValue(String propertyName, dynamic value) {
    _formKey.currentState?.patchValue({propertyName: value});
    data._currentFormData[propertyName] = value;
    this.updateAllUIComponents();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiCreateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiUpdateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  // Private method. Only for use in this class.
  bool __checkValidBeforeSave() {
    return !block.__isSaving && (_formKey.currentState?.validate() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> saveForm() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "saveForm",
      parameters: {},
      navigate: null,
    );
    //
    if (!__checkValidBeforeSave()) {
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
    _TaskUnit taskUnit = _SaveFormSaveTaskUnit(
      xFormModel: xFormModel,
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
