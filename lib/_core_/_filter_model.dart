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

  bool _lockFireChange = false;
  bool _applyDefaultFilterCriteria = false;

  late final MasterDataStructure _masterDataStructure;

  bool _initiated = false;

  // ***************************************************************************
  // ***************************************************************************

  FilterModel() {
    __registerMasterDataStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitFilterViewChanged({
    required _XFilterModel xFilterModel,
  }) async {
    __assertThisXFilterModel(xFilterModel);
    //
    FILTER_CRITERIA? filterCriteria = await _startNewFilterTransaction(
      filterInput: null,
      formViewInstantValue: _formKey.currentState?.instantValue,
    );
    return filterCriteria != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// MasterDataStructure registerMasterDataStructure() {
  ///   return MasterDataStructure(
  ///     optionedMasterProps: [
  ///       OptionedMasterProp(
  ///         propName: "company",
  ///         children: [
  ///           MasterProperty(
  ///              propName: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  MasterDataStructure? registerMasterDataStructure();

  // ***************************************************************************
  // ***************************************************************************

  void __registerMasterDataStructure() {
    _masterDataStructure = registerMasterDataStructure() ??
        MasterDataStructure(
          allPropNames: [],
          optionedMasterProps: [],
        );
  }

  // ***************************************************************************
  // ***************************************************************************

  XList? getMasterPropDataXList(String propName) {
    return _masterDataStructure._getMasterDataXList(propName);
  }

  List<DATA> getMasterPropDataList<DATA>(String propName) {
    return (_masterDataStructure._getMasterDataXList(propName)?.items
            as List<DATA>?) ??
        <DATA>[];
  }

  // ***************************************************************************
  // ***************************************************************************

  DATA? getMasterPropDataCustom<DATA>(String propName) {
    return _masterDataStructure._getMasterPropDataCustom(propName) as DATA?;
  }

  // ***************************************************************************
  // ***************************************************************************

  void setMasterPropDataCustom({
    required String propName,
    required Object? object,
  }) {
    _masterDataStructure._setTempMasterPropDataCustom(
      propName: propName,
      object: object,
    );
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
  /// Return null is error.
  ///
  @ImportantMethodAnnotation()
  Future<FILTER_CRITERIA?> _startNewFilterTransaction({
    required FILTER_INPUT? filterInput,
    required Map<String, dynamic>? formViewInstantValue,
  }) async {
    if (filterInput != null && formViewInstantValue != null) {
      throw "Invalid Call";
    }
    print("#~~~~~~~~~~~> _startNewFilterTransaction");
    if (!_initiated && _formKey.currentState != null) {
      _initiated = true;
      data._initialFilterData(_formKey.currentState!.instantValue);
    }
    print("@~~~~~~~~~~~~~~~~~~~~~~~> 1");
    try {
      _masterDataStructure._resetTemporaryForNewTransaction(
        currentFormData: filterInput != null
            ? {} // Clear All.
            : formViewInstantValue ?? data._currentFormData,
      );
      print("@~~~~~~~~~~~~~~~~~~~~~~~> 2");
      _masterDataStructure._printTemporaryInfo();
      //
      for (OptionedMasterProp masterProp
          in _masterDataStructure._rootOptionedMasterProps) {
        //
        // May throw ApiError.
        //
        await _loadOptionedMasterDataCascade(
          filterInput: filterInput,
          parentMasterPropValue: null,
          optionedMasterProp: masterProp,
        );
      }
      print("@~~~~~~~~~~~~~~~~~~~~~~~> 3");
      if (filterInput != null) {
        for (CommonMasterProp commonMasterProp
            in _masterDataStructure._commonMasterProps) {
          Object? value = filterInputToCommonMasterPropValue(
            filterInput: filterInput,
            propName: commonMasterProp.propName,
          );
          _masterDataStructure._setTempMasterPropDataCommon(
            propName: commonMasterProp.propName,
            value: value,
          );
        }
      }
      print("@~~~~~~~~~~~~~~~~~~~~~~~> 4");
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_startNewFilterTransaction",
        error: "Error _startNewFilterTransaction: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return null;
    }
    print("@~~~~~~~~~~~~~~~~~~~~~~~> 5");
    //
    _printStructureAndTempData();
    //
    // Apply Temporary data to real data:
    //
    this.data._currentFormData
      ..updateAll((k, v) => null)
      ..addAll(_masterDataStructure._tempCurrentFormData);
    this._masterDataStructure._applyAllTempDataToReal();
    //
    if (_formKey.currentState != null) {
      try {
        // IMPORTANT: To avoid infinite loops.
        _lockFireChange = true;
        //
        Map<String, dynamic> minPatch = PatchUtils.getMinPatchValues(
          currentValues: _formKey.currentState!.instantValue,
          patchValues: data._currentFormData,
        );
        // TODO: Eliminate flickering. (Test in song1a)
        // This line of code causes flickering on FilterView
        // _formKey.currentState?.patchValue(data._currentFormData);
        _formKey.currentState?.patchValue(minPatch);
      } finally {
        _lockFireChange = false;
      }
    }
    print("@~~~~~~~~~~~~~~~~~~~~~~~> 6");
    //
    try {
      // If no error:
      FILTER_CRITERIA newCriteria =
          createFilterCriteria(dataMap: data.currentFormData);
      _filterCriteria = newCriteria;
      //
      this.data._filterDataState = DataState.ready;
      print("@~~~~~~~~~~~~~~~~~~~~~~~> 7");
      return newCriteria;
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
      return null;
    }
    print("FINISH: _startNewFilterTransaction");
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XList?> prepareMasterPropDataForListType({
    required FILTER_INPUT? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  });

  ///
  /// Abstract method:
  ///
  Future<Object?> prepareMasterPropDataForCustomType({
    required FILTER_INPUT? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadOptionedMasterDataCascade({
    required FILTER_INPUT? filterInput,
    required Object? parentMasterPropValue,
    required OptionedMasterProp optionedMasterProp,
  }) async {
    final String propName = optionedMasterProp.propName;

    switch (optionedMasterProp.type) {
      case OptionedMasterPropType.listable:
        // Get current MasterProp data:
        XList? tempXList =
            _masterDataStructure._getTempMasterDataXList(propName);
        //
        // Load OptionedMasterProp data from Rest API.
        // May throw ApiError.
        //
        tempXList ??= await prepareMasterPropDataForListType(
          filterInput: filterInput,
          parentMasterPropValue: parentMasterPropValue,
          propName: propName,
        );
        //
        // IMPORTANT: Do not use empty list here
        // to avoid cast Error (List<dynamic> to List<ITEM>)
        //
        List? currentSelectedItems; // will be null or not empty.
        // Candidate Selected Items:
        List? candidateSelectedItems;
        if (tempXList != null) {
          MasterPropValueWrap? inputValueWrap;
          if (filterInput != null) {
            inputValueWrap = _filterInputToOptionedMasterPropValue(
              filterInput: filterInput,
              materPropData: tempXList,
              propName: propName,
            );
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
            currentSelectedItems = tempXList.findItemsInListByDynamics(
              dynamicValues: currentSelectedItems,
            );
          }
          // Candidate Selected Items:
          candidateSelectedItems = inputValueWrap?.value;

          if (candidateSelectedItems == null ||
              candidateSelectedItems.isEmpty) {
            candidateSelectedItems = currentSelectedItems;
          }
        } else {
          currentSelectedItems = null;
          candidateSelectedItems = null;
        }
        //
        _masterDataStructure._setTempMasterPropDataXList(
          propName: propName,
          tempXList: tempXList,
        );
        //
        // TODO: Double check this code:
        //
        if (candidateSelectedItems != null &&
            candidateSelectedItems.isNotEmpty) {
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
            _masterDataStructure
                ._updateTempData({propName: candidateSelectedItem});
          }
        } else {
          // IMPORTANT:
          //  - Update from ROOTs to LEAVES
          //  - And make sure children-OptionedMasterProp to null if parent-Value is null or not selected.
          _masterDataStructure._updateTempData({propName: null});
        }
      case OptionedMasterPropType.custom:
        Object? dataObject = this.getMasterPropDataCustom(propName);
        if (dataObject == null) {
          dataObject = await prepareMasterPropDataForCustomType(
            filterInput: filterInput,
            parentMasterPropValue: parentMasterPropValue,
            propName: propName,
          );
          this.setMasterPropDataCustom(
            propName: propName,
            object: dataObject,
          );
          // Current value:
          final dynamic currentValue = this.data.getProperty(propName);

          // // Candidate Selected Items:
          // List<dynamic>? candidateSelectedItems = xList?.candidateSelectedItems;
          //
          // //
          // // TODO: Double check this code:
          // //
          // if (candidateSelectedItems != null &&
          //     candidateSelectedItems.isNotEmpty) {
          //   try {
          //     this.data._updateFilterData({propName: candidateSelectedItems});
          //   } catch (e) {
          //     Object? candidateSelectedItem = candidateSelectedItems.first;
          //     this.data._updateFilterData({propName: candidateSelectedItem});
          //   }
          // }
        }
    } // End switch

    //
    Object? tempSelectedMasterPropValue =
        this._masterDataStructure._getTempCurrentPropValue(propName: propName);
    if (tempSelectedMasterPropValue != null) {
      for (OptionedMasterProp child in optionedMasterProp.children) {
        await _loadOptionedMasterDataCascade(
          filterInput: filterInput,
          parentMasterPropValue: tempSelectedMasterPropValue,
          optionedMasterProp: child,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called after [prepareMasterPropDataForListType] and [prepareMasterPropDataForCustomType].
  ///
  /// Use the data obtained from the [prepareMasterPropDataForListType]
  /// and [prepareMasterPropDataForCustomType] methods to specify default search criteria.
  ///
  /// For example, after getting the list of companies.
  /// Use a certain company in the list as the default criteria for the filter.
  ///
  /// ```dart
  /// @override
  /// Map<String, dynamic> initialCriteriaDataMap() {
  ///      var defaultCompany = companyXList.getItemById(123);
  ///
  ///      return {
  ///         "company": defaultCompany,
  ///      };
  /// }
  /// ```
  ///
  Map<String, dynamic> initialCriteriaDataMap();

  // ***************************************************************************
  // ***************************************************************************

  Object? filterInputToCommonMasterPropValue({
    required FILTER_INPUT filterInput,
    required String propName,
  });

  ///
  /// This method is called after [prepareMasterData] and [initialCriteriaDataMap] methods.
  ///
  /// For example, after getting a list of companies from the [prepareMasterData] method.
  /// Use [FilterInput] to identify a company that will be used as a criterion for the filter.
  ///
  /// ```dart
  /// @override
  /// MasterPropValueWrap? filterInputToMasterPropValue({
  ///     required ExampleFilterInput filterInput,
  ///     required XList materPropData,
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
  MasterPropValueWrap? filterInputToOptionedMasterPropValue({
    required FILTER_INPUT filterInput,
    required XList materPropData,
    required String propName,
  });

  MasterPropValueWrap? _filterInputToOptionedMasterPropValue({
    required FILTER_INPUT filterInput,
    required XList materPropData,
    required String propName,
  }) {
    MasterPropValueWrap? wrap = filterInputToOptionedMasterPropValue(
      filterInput: filterInput,
      materPropData: materPropData,
      propName: propName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.value;
    return MasterPropValueWrap(
      materPropData.findItemsInListByDynamics(
        dynamicValues: value,
      ),
    );
  }

  ///
  /// This method is called after [prepareMasterData] and [initialCriteriaDataMap] methods.
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
  /// calling [prepareMasterPropDataForListType] and [prepareMasterPropDataForCustomType]
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
    _taskUnitQueue.addTaskUnit(taskUnit);
    await FlutterArtist.storage._executeTaskUnitQueue();
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
