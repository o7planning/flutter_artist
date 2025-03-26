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
    // data._formDataState = DataState.pending;
    //
    await _startNewFormTransaction(
      extraFormInput: null,
      filterCriteria: block.data.filterCriteria,
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
    // forceForm = true
    //
    __loadCount++;
    print(
        "@ ~~~~~~~~~~~~~~~~> ${getClassName(this)}._unitLoadForm - LOAD - $__loadCount");
    //
    ITEM_DETAIL? refreshedItemDetail = this.block.data.currentItemDetail;
    FILTER_CRITERIA? filterCriteria = this.block.data.filterCriteria;
    EXTRA_FORM_INPUT? extraFormInput =
        thisXFormModel.extraFormInput as EXTRA_FORM_INPUT?;
    bool isNew = this.data.isNew;
    //
    // bool error = await _prepareMasterDataAndFormData(
    //   extraFormInput: extraFormInput,
    //   filterCriteria: filterCriteria,
    //   refreshedItemDetail: refreshedItemDetail,
    //   isNew: isNew,
    // );
    await _startNewFormTransaction(
      extraFormInput: extraFormInput,
      filterCriteria: filterCriteria,
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
  Future<void> _startNewFormTransaction({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
  }) async {
    // if (data._filterDataState == DataState.ready && extraFormInput == null) {
    //   print("Ready ---------------------> return");
    //   // return _filterCriteria;
    // }
    print("#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFormTransaction");

    final ITEM_DETAIL? itemDetail = block.data.currentItemDetail;
    try {
      // All values including hidden values (not on the user interface).
      Map<String, dynamic> allNewValue = {...data._currentFormData};

      // Update values from view (On the user Interface).
      allNewValue.addAll(_formKey.currentState?.instantValue ?? {});
      //
      if (!_initiated && _formKey.currentState != null) {
        _initiated = true;
        data._initialFormData2(allNewValue);
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
      // if (extraFormInput != null) {
      //   for (CommonProp commonOptProp in _formPropsStructure._commonProps) {
      //     Object? value = extraFormInputToCommonPropValue(
      //       extraFormInput: extraFormInput,
      //       propName: commonOptProp.propName,
      //     );
      //     _formPropsStructure._setTempPropDataCommon(
      //       propName: commonOptProp.propName,
      //       value: value,
      //     );
      //   }
      // } else {
      //   if (!_defaultValueInitiated) {
      //     for (CommonProp commonOptProp in _formPropsStructure._commonProps) {
      //       Object? value = specifyDefaultCommonPropValue(
      //         propName: commonOptProp.propName,
      //       );
      //       _formPropsStructure._setTempPropDataCommon(
      //         propName: commonOptProp.propName,
      //         value: value,
      //       );
      //     }
      //   }
      // }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_startNewFormTransaction",
        error: "Error _startNewFormTransaction: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      data._formDataState = DataState.error;
    }
    //
    _printStructureAndTempData("@3");
    Map<String, dynamic> commonPropValue = {};
    if (itemDetail != null) {
      try {
        commonPropValue = getCommonPropValuesFromItemDetail(
          itemDetail: itemDetail,
        );
        for (String propName in commonPropValue.keys) {
          _formPropsStructure._setTempPropDataCommon(
            propName: propName,
            value: commonPropValue[propName],
          );
        }
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "getCommonPropValuesFromItemDetail",
          error: "Error getCommonPropValuesFromItemDetail: $e",
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        this.data._clearWithDataState(
              formDataState: DataState.error,
            );
        // return false;
      }
    }
    // itemDetail == null
    else {
      Map<String, dynamic> commonPropValueDefault = {};
      Map<String, dynamic> commonPropValueExtra = {};
      if (extraFormInput != null) {
        commonPropValueExtra = getCommonPropValuesFromExtraFormInput(
          extraFormInput: extraFormInput,
        );
      } else {
        if (!_defaultValueInitiated) {
          commonPropValueDefault = specifyDefaultCommonPropValues();
        }
      }
      for (String propName in commonPropValueDefault.keys) {
        _formPropsStructure._setTempPropDataCommon(
          propName: propName,
          value: commonPropValueDefault[propName],
        );
      }
      for (String propName in commonPropValueExtra.keys) {
        _formPropsStructure._setTempPropDataCommon(
          propName: propName,
          value: commonPropValueExtra[propName],
        );
      }
    }
    //

    //
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
      data._formDataState = DataState.ready;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "createFormCriteria",
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
    final String propName = optProp.propName;

    final OptProp? optPropParent = optProp?.parent;

    // Get current OptProp data:
    XOptionedData? optPropData = _formPropsStructure._getOptPropData(propName);

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
      propName: propName,
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
          selectedValueWrap = _extraFormInputToOptPropValue(
            extraFormInput: extraFormInput,
            optPropData: optPropData,
            propName: propName,
          );
        } else {
          if (!_defaultValueInitiated) {
            selectedValueWrap = __specifyDefaultOptPropValue(
              optPropData: optPropData,
              propName: propName,
            );
          }
        }
      }
      // currentItemDetail != null
      else {
        selectedValueWrap = getOptPropValueFromItemDetail(
          itemDetail: currentItemDetail,
          optPropData: optPropData,
          propName: propName,
        );
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _formPropsStructure._getTempCurrentPropValue(
        propName: propName,
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
        currentSelectedItems = optPropData.findItemsInListByDynamics(
          dynamicValues: currentSelectedItems,
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
      propName: propName,
      optionedData: optPropData,
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
        _formPropsStructure._updateTempData({propName: candidateSelectedItem});
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _formPropsStructure._updateTempData({propName: candidateSelectedItems});
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updateTempData({propName: null});
    }

    //
    Object? tempSelectedPropValue =
        this._formPropsStructure._getTempCurrentPropValue(
              propName: propName,
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

  PropValue? __specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  }) {
    PropValue? wrap = specifyDefaultOptPropValue(
      optPropData: optPropData,
      propName: propName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.value;
    return PropValue(
      optPropData.findItemsInListByDynamics(
        dynamicValues: value,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  PropValue? _extraFormInputToOptPropValue({
    required EXTRA_FORM_INPUT extraFormInput,
    required XOptionedData optPropData,
    required String propName,
  }) {
    PropValue? wrap = extraFormInputToOptPropValue(
      extraFormInput: extraFormInput,
      optPropData: optPropData,
      propName: propName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.value;
    return PropValue(
      optPropData.findItemsInListByDynamics(
        dynamicValues: value,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> getCommonPropValuesFromExtraFormInput({
    EXTRA_FORM_INPUT extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> getCommonPropValuesFromItemDetail({
    ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> specifyDefaultCommonPropValues();

  // ***************************************************************************
  // ***************************************************************************

  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  });

  // ***************************************************************************
  // ***************************************************************************

  PropValue? getOptPropValueFromItemDetail({
    required ITEM_DETAIL itemDetail,
    required XOptionedData optPropData,
    required String propName,
  });

  // ***************************************************************************
  // ***************************************************************************

  PropValue? extraFormInputToOptPropValue({
    required EXTRA_FORM_INPUT extraFormInput,
    required XOptionedData optPropData,
    required String propName,
  });

  // ***************************************************************************
  // ***************************************************************************

  // Object? extraFormInputToCommonPropValue({
  //   required EXTRA_FORM_INPUT extraFormInput,
  //   required String propName,
  // });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XOptionedData?> callApiLoadOptPropData({
    required EXTRA_FORM_INPUT? extraFormInput,
    required Object? parentOptPropValue,
    required String propName,
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

  @Deprecated("Xoa di khong su dung nua")
  Future<bool> _prepareMasterDataAndFormData({
    required EXTRA_FORM_INPUT? extraFormInput,
    required FILTER_CRITERIA? filterCriteria,
    required ITEM_DETAIL? refreshedItemDetail,
    required bool isNew,
  }) async {
    print(">>> ${getClassName(this)}._prepareMasterDataAndFormData()");
    bool error = false;
    try {
      //
      // May throw ApiError.
      //
      __prepareFormMasterDataCount++;
      await prepareFormMasterData(
        filterCriteria: filterCriteria,
        extraFormInput: extraFormInput,
        refreshedItem: refreshedItemDetail,
        isNew: isNew,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareFormMasterData",
        error: "Error prepareFormMasterData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      error = true;
    }
    //
    if (error) {
      this.data._clearWithDataState(
            formDataState: DataState.error,
          );
      return false;
    }
    //
    Map<String, dynamic> newFormData = {};
    try {
      newFormData = prepareFormData(
        filterCriteria: filterCriteria,
        extraFormInput: extraFormInput,
        refreshedItem: refreshedItemDetail,
        isNew: isNew,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareFormData",
        error: "Error prepareFormData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      error = true;
    }
    //
    if (error) {
      this.data._clearWithDataState(
            formDataState: DataState.error,
          );
      return false;
    }
    //
    try {
      this.data._updateFormData(newFormData);
      this._formKey.currentState?.patchValue(newFormData);
      //
      this.data._setCurrentItem(
            refreshedItemDetail: refreshedItemDetail,
            formMode: isNew //
                ? FormMode.creation
                : FormMode.edit,
            formDataState: DataState.ready,
          );
      //
      updateAllUIComponents(); // TODO: Xu ly loi?
      this.block.updateControlBarWidgets();
      return true;
    } catch (e, stackTrace) {
      error = true;
      //
      _handleError(
        shelf: shelf,
        methodName: "_updateFormData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
    }
    //
    if (error) {
      this.data._clearWithDataState(
            formDataState: DataState.error,
          );
      return false;
    }
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

  ///
  /// Call this method to initialize the necessary data for the Form.
  /// For example, the list of items of the [Dropdown].
  ///
  /// This method is called before [prepareFormData] method.
  ///
  /// Example:
  /// ```dart
  /// Future<void> prepareFormMasterData({
  ///     required EmptyFilterCriteria? filterCriteria,
  ///     required EmptyExtraFormInput? extraFormInput,
  ///     required EmployeeData? refreshedItem,
  ///     required bool isNew,
  /// }) {
  ///   ApiResult<CompanyPage> result1 = await companyApi.getCompanyPage();
  ///   // Throw ApiError
  ///   result1.throwIfError();
  ///   this.companyPage = result1.data;
  ///   CompanyInfo? company = this.companyPage.getSelectedCompany()
  ///
  ///   ApiResult<DepartmentPage> result2 = await deptApi.getDepartmentPage(company);
  ///   // Throw ApiError
  ///   result2.throwIfError();
  ///   this.departmentPage = result2.data;
  ///   ...
  /// }
  /// ```
  ///
  @Deprecated("Xoa di khong su dung nua")
  Future<void> prepareFormMasterData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called after [prepareFormMasterData].
  ///
  @Deprecated("Xoa di, khong su dung nua.")
  Map<String, dynamic> prepareFormData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
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
