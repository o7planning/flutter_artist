part of '../flutter_artist.dart';

abstract class FormModel<
    ID extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> extends _XBase {
  int __loadCount = 0;

  int get loadCount => __loadCount;

  int __formTransactionCount = 0;

  int get formTransactionCount => __formTransactionCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  String get id {
    return "block-form > ${shelf.name} > ${block.name}";
  }

  bool _changeEventLocked = false;

  FormMode get formMode => _formPropsStructure.formMode;

  DataState get formDataState => _formPropsStructure._formDataState;

  Shelf get shelf => block.shelf;

  late final Block<
      ID, //
      Object,
      ITEM_DETAIL,
      FilterInput,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  bool _defaultValueInitiated = false;

  final _defaultAutovalidateMode = AutovalidateMode.onUserInteraction;

  late AutovalidateMode autovalidateMode = _defaultAutovalidateMode;

  final Map<_RefreshableWidgetState, _XState> _formWidgetStates = {};

  // ***************************************************************************

  late final FormPropsStructure _formPropsStructure;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

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
    EXTRA_FORM_INPUT? extraFormInput =
        thisXFormModel.extraFormInput as EXTRA_FORM_INPUT?;
    //
    await _startNewFormTransaction(
      extraFormInput: extraFormInput,
      isItemFirstLoad: true,
    );
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitSaveForm({required _XFormModel thisXFormModel}) async {
    FILTER_CRITERIA? blockCurrentFilterCriteria = block.filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      throw AppException(message: "FilterCriteria is null");
    }
    if (!__checkValidBeforeSave()) {
      return false;
    }
    print("@~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _unitSaveForm");
    final Map<String, dynamic> formMapData =
        _formPropsStructure.currentFormData;
    //
    String calledMethodName = _formPropsStructure.isNew //
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
      Object? parentBlockItem = block.parent?.currentItem;
      //
      result = _formPropsStructure.isNew
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
        blockCurrentFilterCriteria: blockCurrentFilterCriteria,
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
  FormPropsStructure registerPropsStructure();

  // ***************************************************************************
  // ***************************************************************************

  void __registerPropsStructure() {
    _formPropsStructure = registerPropsStructure();
    _formPropsStructure.formModel = this;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @ImportantMethodAnnotation()
  Future<bool> _startNewFormTransaction({
    required EXTRA_FORM_INPUT? extraFormInput,
    required bool isItemFirstLoad,
  }) async {
    FILTER_CRITERIA? blockCurrentFilterCriteria = block.filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      throw AppException(message: "FilterCriteria is null");
    }
    __formTransactionCount++;
    print(
        "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFormTransaction, isItemFirstLoad: $isItemFirstLoad");

    final ITEM_DETAIL? itemDetail = block.currentItemDetail;
    final FormMode currentFormMode = formDataState == DataState.none
        ? FormMode.none
        : itemDetail == null
            ? FormMode.creation
            : FormMode.edit;
    _formPropsStructure._setFormMode(currentFormMode);
    bool isNoneMode = currentFormMode == FormMode.none;
    bool isCreationMode = currentFormMode == FormMode.creation;
    //
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
    }
    //
    // Update from FormView:
    //
    else {
      allNewValue.addAll(_formPropsStructure.currentFormData);
      // Update values from view (On the user Interface).
      allNewValue.addAll(_formKey.currentState?.instantValue ?? {});
    }
    //
    _formPropsStructure._initTemporaryForNewTransaction(
      newCurrentFormData: allNewValue,
    );
    //
    // Load OptProp Data:
    //
    try {
      for (MultiOptProp multiOptProp in _formPropsStructure._rootOptProps) {
        //
        // Load OptProp Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadMultiOptPropDataCascade(
          blockCurrentFilterCriteria: blockCurrentFilterCriteria,
          extraFormInput: extraFormInput,
          parentMultiOptPropValue: null,
          multiOptProp: multiOptProp,
          isItemFirstLoad: isItemFirstLoad,
        );
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiLoadMultiOptPropData",
        error: "Error callApiLoadMultiOptPropData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      __applyWithDataState(
        formDataState: DataState.error,
        isItemFirstLoad: isItemFirstLoad,
      );
      return false;
    }
    //
    // Get SimpleProp Value:
    //
    Map<String, dynamic> simplePropValue = {};
    if (isItemFirstLoad) {
      if (itemDetail != null) {
        try {
          simplePropValue = await getSimplePropValuesFromItemDetail(
            filterCriteria: blockCurrentFilterCriteria,
            itemDetail: itemDetail,
          );
          for (String propName in simplePropValue.keys) {
            _formPropsStructure._setTempSimplePropValue(
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
          __applyWithDataState(
            formDataState: DataState.error,
            isItemFirstLoad: isItemFirstLoad,
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
            for (String propName in simplePropValueDefault.keys) {
              _formPropsStructure._setTempSimplePropValue(
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
            __applyWithDataState(
              formDataState: DataState.error,
              isItemFirstLoad: isItemFirstLoad,
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
              _formPropsStructure._setTempSimplePropValue(
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
            __applyWithDataState(
              formDataState: DataState.error,
              isItemFirstLoad: isItemFirstLoad,
            );
            return false;
          }
        }
      }
    }
    return __applyWithDataState(
      formDataState: DataState.ready,
      isItemFirstLoad: isItemFirstLoad,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __applyWithDataState({
    required DataState formDataState,
    required bool isItemFirstLoad,
  }) {
    try {
      //
      // Update Real FromData from Temporary FormData:
      //
      _formPropsStructure._updateTempToReal();

      //
      // UPDATE OPT-DATA:
      //  - optProp._xOptionedData = optProp._tempXOptionedData;
      //
      // _formPropsStructure._applyAllTempDataToReal();
      //
      if (isItemFirstLoad) {
        _formPropsStructure._setInitialFormDataForItemFirstLoad();
      }

      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      _defaultValueInitiated = true;
      _formPropsStructure._setFormDataState(formDataState);
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
      // Note [_formKeyPatchValue] NOT WORK!.
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      _formPropsStructure._setFormDataState(DataState.error);
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
    // May be new selected parent value.
    required Object? parentMultiOptPropValue,
    required MultiOptProp multiOptProp,
    required bool isItemFirstLoad,
  }) async {
    final String multiOptPropName = multiOptProp.propName;

    final MultiOptProp? optPropParent = multiOptProp.parent;

    // Get current OptProp data:
    XOptionedData? multiOptPropXData =
        _formPropsStructure._getOptPropXData(multiOptPropName);

    if (optPropParent != null) {
      XOptionedData? tempXOptionedParent =
          _formPropsStructure._getTempOptPropData(
        optPropParent.propName,
      );
      //
      if (tempXOptionedParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptPropValueOLD =
            _formPropsStructure._getCurrentPropValue(
          propName: optPropParent.propName,
        );

        // Parent Value change?
        bool isSame = tempXOptionedParent.isSameItemOrItemList(
          itemOrItemList1: parentOptPropValueOLD,
          itemOrItemList2: parentMultiOptPropValue,
        );
        if (!isSame) {
          multiOptPropXData = null;
        }
      } else {
        multiOptPropXData = null;
      }
    }
    //
    if (multiOptPropXData == null) {
      _formPropsStructure._setTempMultiOptPropXData(
        multiOptPropName: multiOptPropName,
        multiOptXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updatePropsTempValues({multiOptPropName: null});
    }
    //
    // Load OptProp data from Rest API.
    // May throw ApiError.
    //
    multiOptPropXData ??= await callApiLoadMultiOptPropData(
      filterCriteria: blockCurrentFilterCriteria,
      extraFormInput: extraFormInput,
      parentMultiOptPropValue: parentMultiOptPropValue,
      multiOptPropName: multiOptPropName,
    );
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    ValueWrap? selectedValueWrap;
    final ITEM_DETAIL? currentItemDetail = block.currentItemDetail;
    //
    if (multiOptPropXData != null) {
      if (isItemFirstLoad) {
        if (currentItemDetail == null) {
          if (extraFormInput != null) {
            selectedValueWrap = _getOptPropValueFromExtraFormInput(
              extraFormInput: extraFormInput,
              multiOptPropXData: multiOptPropXData,
              multiOptPropName: multiOptPropName,
            );
          } else {
            if (!_defaultValueInitiated) {
              selectedValueWrap = __specifyDefaultMultiOptPropValue(
                multiOptPropXData: multiOptPropXData,
                multiOptPropName: multiOptPropName,
              );
            }
          }
        }
        // currentItemDetail != null
        else {
          selectedValueWrap = getMultiOptPropValueFromItemDetail(
            itemDetail: currentItemDetail,
            multiOptPropXData: multiOptPropXData,
            multiOptPropName: multiOptPropName,
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
        currentSelectedItems = multiOptPropXData.findInternalItemsByDynamics(
          dynamicValues: currentSelectedItems,
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
        );
      }
      // Candidate Selected Items:
      candidateSelectedItems = selectedValueWrap?.values;

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
      multiOptXData: multiOptPropXData,
    );
    // TODO: Dangerous, check not null:
    candidateSelectedItems = multiOptPropXData?.findInternalItemsByDynamics(
          dynamicValues: candidateSelectedItems,
          //
          // IMPORTANT: Add not found item to internal list.
          //
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
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
        this._formPropsStructure._getTempCurrentPropValue(
              propName: multiOptPropName,
            );

    if (tempSelectedPropValue != null) {
      for (MultiOptProp child in multiOptProp.children) {
        await _loadMultiOptPropDataCascade(
          blockCurrentFilterCriteria: blockCurrentFilterCriteria,
          extraFormInput: extraFormInput,
          parentMultiOptPropValue: tempSelectedPropValue,
          multiOptProp: child,
          isItemFirstLoad: isItemFirstLoad,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getCurrentPropValue(String propName) {
    return _formPropsStructure._getCurrentPropValue(propName: propName);
  }

  XOptionedData? getOptPropXData(String propName) {
    return _formPropsStructure._getOptPropXData(propName);
  }

  dynamic getOptPropData(String propName) {
    XOptionedData? multiOptPropXData = getOptPropXData(propName);
    dynamic data = multiOptPropXData?.data;
    if (data != null) {
      return data;
    } else {
      return data;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? __specifyDefaultMultiOptPropValue({
    required String multiOptPropName,
    required XOptionedData multiOptPropXData,
  }) {
    ValueWrap? wrap = specifyDefaultMultiOptPropValue(
      multiOptPropXData: multiOptPropXData,
      multiOptPropName: multiOptPropName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.values;
    return ValueWrap.multi(
      multiOptPropXData.findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: true,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? _getOptPropValueFromExtraFormInput({
    required String multiOptPropName,
    required XOptionedData multiOptPropXData,
    required EXTRA_FORM_INPUT extraFormInput,
  }) {
    ValueWrap? wrap = getMultiOptPropValueFromExtraFormInput(
      extraFormInput: extraFormInput,
      multiOptPropXData: multiOptPropXData,
      multiOptPropName: multiOptPropName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.values;
    return ValueWrap.multi(
      multiOptPropXData.findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: true,
        removeCurrentNotFoundItems: true,
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

  Future<Map<String, dynamic>> getSimplePropValuesFromItemDetail({
    required FILTER_CRITERIA filterCriteria,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<Map<String, dynamic>?> specifyDefaultSimplePropValues({
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? specifyDefaultMultiOptPropValue({
    required String multiOptPropName,
    required XOptionedData multiOptPropXData,
  });

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

  ValueWrap? getMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required XOptionedData multiOptPropXData,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? getMultiOptPropValueFromExtraFormInput({
    required String multiOptPropName,
    required XOptionedData multiOptPropXData,
    required EXTRA_FORM_INPUT extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XOptionedData?> callApiLoadMultiOptPropData({
    required String multiOptPropName,
    required Object? parentMultiOptPropValue,
    required FILTER_CRITERIA filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState formDataState}) {
    try {
      _formPropsStructure._clearFormDataWithState(
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
    return _formPropsStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    Actionable actionable = block._isEnableFormToModify();
    print("Action >>>>>>>>>> ${actionable.message}");
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

  // TODO: Change name!
  // Do not call this method in library.
  Map<String, dynamic> initFormValue() {
    return _formPropsStructure.currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getFormInitialValue(String propertyName) {
    return _formPropsStructure.initialFormData[propertyName];
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getFormInstantValue(String propertyName) {
    return _formPropsStructure.currentFormData[propertyName];
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

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiCreateItem({
    required FILTER_CRITERIA filterCriteria,
    required Object? parentBlockItem,
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiUpdateItem({
    required FILTER_CRITERIA filterCriteria,
    required Object? parentBlockItem,
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
