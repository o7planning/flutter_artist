part of '../flutter_artist.dart';

abstract class FilterModel<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _XBase {
  late final Shelf shelf;

  late final String name;

  String get id {
    return "filter-model > ${shelf.name} > $name";
  }

  final List<Block> _blocks = [];

  List<Block> get blocks => [..._blocks];

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => [..._scalars];

  int? __currentSuccessCriteriaId;

  int? get currentSuccessCriteriaId => __currentSuccessCriteriaId;

  ///
  /// Map<CriteriaId, EmptyFilterCriteria>
  ///
  final Map<int, FILTER_CRITERIA> __filterCriteriasMap = {};

  FILTER_CRITERIA? get currentSuccessFilterCriteria {
    return __currentSuccessCriteriaId == null
        ? null
        : __filterCriteriasMap[__currentSuccessCriteriaId];
  }

  FILTER_CRITERIA? _filterCriteria;

  late final FilterModelData data = FilterModelData(filterModel: this);
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  bool _defaultValueInitiated = false;

  late final PropsStructure _masterDataStructure;

  bool _initiated = false;

  bool _lockAddMoreQuery = false;

  bool get lockAddMoreQuery => _lockAddMoreQuery;

  // ***************************************************************************
  // ***************************************************************************

  FilterModel() {
    __registerPropsStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitFilterViewChanged({
    required _XFilterModel xFilterModel,
  }) async {
    __assertThisXFilterModel(xFilterModel);
    //
    data._filterDataState = DataState.pending;
    //
    FILTER_CRITERIA? filterCriteria = await _startNewFilterTransaction(
      filterInput: null,
    );
    return filterCriteria != null;
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
  PropsStructure? registerPropsStructure();

  // ***************************************************************************
  // ***************************************************************************

  void __registerPropsStructure() {
    _masterDataStructure = registerPropsStructure() ??
        PropsStructure(
          allPropNames: [],
          optProps: [],
        );
  }

  // ***************************************************************************
  // ***************************************************************************

  XOptionedData? getOptPropXData(String propName) {
    return _masterDataStructure._getOptPropData(propName);
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

  OptPropType? getOptPropType(String propName) {
    return _masterDataStructure._getOptPropType(propName);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printStructureAndTempData() {
    _masterDataStructure._printTemporaryInfo();
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
      _lockAddMoreQuery = true;
      //
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
      _lockAddMoreQuery = false;
    }
  }

  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    try {
      _lockAddMoreQuery = true;
      _formKey.currentState?.patchValue(newCurrentValue);
    } finally {
      _lockAddMoreQuery = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @ImportantMethodAnnotation()
  Future<FILTER_CRITERIA?> _startNewFilterTransaction({
    required FILTER_INPUT? filterInput,
  }) async {
    if (data._filterDataState == DataState.ready && filterInput == null) {
      print("Ready ---------------------> return");
      // return _filterCriteria;
    }
    print("#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFilterTransaction");
    try {
      // All values including hidden values (not on the user interface).
      Map<String, dynamic> allNewValue = {...data._currentFormData};

      // Update values from view (On the user Interface).
      allNewValue.addAll(_formKey.currentState?.instantValue ?? {});
      //
      if (!_initiated && _formKey.currentState != null) {
        _initiated = true;
        data._initialFilterData(allNewValue);
      }
      //
      _masterDataStructure._initTemporaryForNewTransaction(
        currentFormData: filterInput != null
            ? {} // To Clear All.
            : allNewValue,
      );
      _masterDataStructure._printTemporaryInfo();
      //
      for (OptProp optProp in _masterDataStructure._rootOptProps) {
        //
        // Load OptProp Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadOptPropDataCascade(
          filterInput: filterInput,
          parentOptPropValue: null,
          optProp: optProp,
        );
      }
      _masterDataStructure._printTemporaryInfo();
      if (filterInput != null) {
        for (CommonProp commonMasterProp in _masterDataStructure._commonProps) {
          Object? value = filterInputToCommonPropValue(
            filterInput: filterInput,
            propName: commonMasterProp.propName,
          );
          _masterDataStructure._setTempPropDataCommon(
            propName: commonMasterProp.propName,
            value: value,
          );
        }
      } else {
        if (!_defaultValueInitiated) {
          for (CommonProp commonMasterProp
              in _masterDataStructure._commonProps) {
            Object? value = specifyDefaultCommonPropValue(
              propName: commonMasterProp.propName,
            );
            _masterDataStructure._setTempPropDataCommon(
              propName: commonMasterProp.propName,
              value: value,
            );
          }
        }
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_startNewFilterTransaction",
        error: "Error _startNewFilterTransaction: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      data._filterDataState = DataState.error;
      _filterCriteria = null;
      return _filterCriteria;
    }
    //
    _printStructureAndTempData();
    //
    try {
      // Convert Map Data to FilterCriteria Object.
      FILTER_CRITERIA newCriteria = createFilterCriteria(
        dataMap: _masterDataStructure._tempCurrentFormData,
      );
      _filterCriteria = newCriteria;
      //
      this.data._filterDataState = DataState.ready;

      //
      // Update Real FromData from Temporary FormData:
      //
      this.data._currentFormData
        ..updateAll((k, v) => null)
        ..addAll(_masterDataStructure._tempCurrentFormData);

      //
      // UPDATE OPT-DATA:
      //  - optProp._xOptionedData = optProp._tempXOptionedData;
      //
      this._masterDataStructure._applyAllTempDataToReal();
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(newCurrentValue: data._currentFormData);
      //
      _defaultValueInitiated = true;
      _filterCriteria = newCriteria;
      data._filterDataState = DataState.ready;
      return _filterCriteria;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "createFilterCriteria",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      this.data._filterDataState = DataState.error;
      //
      // IMPORTANT: Restore OLD State:
      // Note [_formKeyPatchValueSilently] NOT WORK!.
      //
      _formKeyPatchValueSilently(newCurrentValue: data._currentFormData);
      //
      _filterCriteria = null;
      data._filterDataState = DataState.error;
      return _filterCriteria;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XOptionedData?> callApiLoadOptPropData({
    required FILTER_INPUT? filterInput,
    required Object? parentOptPropValue,
    required String propName,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadOptPropDataCascade({
    required FILTER_INPUT? filterInput,
    required Object? parentOptPropValue, // May be new selected parent value.
    required OptProp optProp,
  }) async {
    final String propName = optProp.propName;

    final OptProp? optPropParent = optProp?.parent;

    // Get current MasterProp data:
    XOptionedData? optPropData = _masterDataStructure._getOptPropData(propName);

    if (optPropParent != null) {
      XOptionedData? tempXOptionedParent =
          _masterDataStructure._getTempOptPropData(
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
      filterInput: filterInput,
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
    if (optPropData != null) {
      PropValue? inputValueWrap;
      if (filterInput != null) {
        inputValueWrap = _filterInputToOptPropValue(
          filterInput: filterInput,
          optPropData: optPropData,
          propName: propName,
        );
      } else {
        if (!_defaultValueInitiated) {
          inputValueWrap = __specifyDefaultOptPropValue(
            optPropData: optPropData,
            propName: propName,
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _masterDataStructure._getTempCurrentPropValue(
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
      candidateSelectedItems = inputValueWrap?.value;

      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    } else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }
    //
    _masterDataStructure._setTempOptPropData(
      propName: propName,
      optionedData: optPropData,
    );
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      try {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptionedMasterProp to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _masterDataStructure
            ._updateTempData({propName: candidateSelectedItems});
      } catch (e) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptionedMasterProp to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _masterDataStructure._updateTempData({propName: candidateSelectedItem});
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptionedMasterProp to null if parent-Value is null or not selected.
      _masterDataStructure._updateTempData({propName: null});
    }

    //
    Object? tempSelectedPropValue =
        this._masterDataStructure._getTempCurrentPropValue(
              propName: propName,
            );

    if (tempSelectedPropValue != null) {
      for (OptProp child in optProp.children) {
        await _loadOptPropDataCascade(
          filterInput: filterInput,
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

  Object? filterInputToCommonPropValue({
    required FILTER_INPUT filterInput,
    required String propName,
  });

  ///
  /// This method is called after [prepareMasterData] method.
  ///
  /// For example, after getting a list of companies from the [prepareMasterData] method.
  /// Use [FilterInput] to identify a company that will be used as a criterion for the filter.
  ///
  /// ```dart
  /// @override
  /// MasterPropValueWrap? filterInputToOptPropValue({
  ///     required ExampleFilterInput filterInput,
  ///     required XOptionedData optPropData,
  ///     required String propName,
  /// }) {
  ///    if(propName == "company") {
  ///       int inputCompanyId = filterInput.filterInput;
  ///       CompanyInfo? inputCompany = materPropData?.getItemById(inputCompanyId);
  ///       return MasterPropValueWrap([inputCompany])
  ///    }
  ///    return null;
  /// }
  /// ```
  ///
  PropValue? filterInputToOptPropValue({
    required FILTER_INPUT filterInput,
    required XOptionedData optPropData,
    required String propName,
  });

  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  });

  Object? specifyDefaultCommonPropValue({
    required String propName,
  });

  PropValue? _filterInputToOptPropValue({
    required FILTER_INPUT filterInput,
    required XOptionedData optPropData,
    required String propName,
  }) {
    PropValue? wrap = filterInputToOptPropValue(
      filterInput: filterInput,
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

  ///
  /// This method is called after [prepareMasterData] method.
  ///
  /// For example, after getting a list of companies from the [prepareMasterData] method.
  /// Use [FilterInput] to identify a company that will be used as a criterion for the filter.
  ///
  /// ```dart
  /// @override
  /// List<Object>? filterInputToCriterionValue({
  ///    required CompanyIdFilterInput filterInput,
  /// }) {
  ///    int inputCompanyId = filterInput.filterInput;
  ///
  ///    TODO: Viet tiep...
  ///
  ///    CompanyInfo inputCompany = companyXList?.getItemById(inputCompanyId);
  ///    return {
  ///       "company": inputCompany,
  ///    };
  /// }
  /// ```
  ///
  List<Object>? filterInputToCriterionValue({
    required FILTER_INPUT? filterInput,
    required String propName,
  }) {
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called immediately after
  /// calling [callApiLoadOptPropData]
  /// methods if there are no errors.
  ///
  FILTER_CRITERIA createFilterCriteria({
    required Map<String, dynamic> dataMap,
  });

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Change name!
  Map<String, dynamic> _initFilterValue() {
    return data._currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  @ImportantMethodAnnotation()
  Future<void> _onChangeFromFilterView() async {
    print("#~~~~~~~~~~~~~~~> _onChangeFromFilterView");
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XFilterModel xFilterModel = xShelf.findXFilterModelByName(name)!;
    _FilterViewChangeTaskUnit taskUnit =
        _FilterViewChangeTaskUnit(xFilterModel: xFilterModel);
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return _filterFragmentWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isBuilding() {
    for (_XState xState in _filterFragmentWidgetStates.values) {
      if (xState.isBuilding) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFilterView() {
    //
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  final Map<_RefreshableWidgetState, _XState> _filterFragmentWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getFilterInputTypeAsString()}, ${getFilterCriteriaTypeAsString()}>";
  }

  String getFilterCriteriaTypeAsString() {
    return FILTER_CRITERIA.toString();
  }

  String getFilterInputTypeAsString() {
    return FILTER_INPUT.toString();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query all Scalars and Blocks of this FilterModel if they are visible on the UI.
  ///
  /// Any Scalar or Block that is not queried will be set to LAZY state.
  ///
  Future<bool> queryAll({
    FILTER_INPUT? filterInput,
  }) async {
    if (_lockAddMoreQuery) {
      return false;
    }
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "queryAll",
      parameters: {
        "filterInput": filterInput,
      },
      navigate: null,
    );
    _XShelf xShelf = await shelf._queryAll(
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: this,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: _scalars
          .map(
            (s) => _ScalarOpt(scalar: s),
          )
          .toList(),
      forceQueryBlockOpts: _blocks
          .map(
            (b) => _BlockOpt(
                block: b,
                queryType: null,
                pageable: null,
                listBehavior: null,
                suggestedSelection: null,
                postQueryBehavior: null),
          )
          .toList(),
      forceQueryFormModelOpts: [],
    );
    // TODO: Xem lai.
    return true;
  }

  // ***************************************************************************
  // *** UI COMPONENTS ***
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _filterFragmentWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    for (State widgetState in _filterFragmentWidgetStates.keys) {
      bool isShowing =
          _filterFragmentWidgetStates[widgetState]?.isShowing ?? false;
      if (isShowing && widgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterViewBuildingState({
    required _RefreshableWidgetState widgetState,
    required bool isBuilding,
  }) {
    _filterFragmentWidgetStates.update(
      widgetState,
      (xState) => xState..isBuilding = isBuilding,
      ifAbsent: () => _XState()..isBuilding = isBuilding,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addFilterFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _filterFragmentWidgetStates.update(
      widgetState,
      (xState) => xState..isShowing = isShowing,
      ifAbsent: () => _XState()..isShowing = isShowing,
    );
    bool activeCURRENT = hasActiveUIComponent();

    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      // TODO: (Kiem tra phuong thuc cung ten trong Block).
      // block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeFilterFragmentWidgetState({
    required State widgetState,
  }) {
    _filterFragmentWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents({bool force = true}) {
    for (_RefreshableWidgetState widgetState in [
      ..._filterFragmentWidgetStates.keys
    ]) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showFilterModelDebugDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    await _showFilterModelInfoDialog(
      context: context,
      locationInfo: "locationInfo", // TODO: Remove.
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXFilterModel(_XFilterModel thisXFilterModel) {
    if (!identical(thisXFilterModel.filterModel, this)) {
      String message =
          "Error Assets filter model: ${thisXFilterModel.filterModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
