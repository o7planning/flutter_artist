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
  bool _firstQueryDone = false;
  bool _applyDefaultFilterCriteria = false;

  late final MasterDataStructure _masterDataStructure;

  // ***************************************************************************
  // ***************************************************************************

  FilterModel() {
    __registerMasterDataStructure();
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

  void setMasterPropDataXList({
    required String propName,
    required XList? xList,
  }) {
    _masterDataStructure._setMasterPropDataXList(
      propName: propName,
      xList: xList,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void setMasterPropDataCustom({
    required String propName,
    required Object? object,
  }) {
    _masterDataStructure._setMasterPropDataCustom(
      propName: propName,
      object: object,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _prinStructureAndData() {
    _masterDataStructure.printInfo();
    print("currentFromData: ${data.currentFormData}");
    print("instantData: ${_formKey.currentState?.instantValue}");
    print("\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @ImportantMethodAnnotation()
  Future<FILTER_CRITERIA?> _prepareAllMasterPropDataAndFilterData({
    required FILTER_INPUT? filterInput,
  }) async {
    print("@~~~~~~~~~~~> 1 _prepareAllMasterPropDataAndFilterData");
    bool error = false;
    try {
      for (OptionedMasterProp masterProp
          in _masterDataStructure._rootOptionedMasterProps) {
        //
        // May throw ApiError.
        //
        await _prepareOptionedMasterDataCascade(
          filterInput: filterInput,
          parentMasterPropValue: null,
          optionedMasterProp: masterProp,
        );
      }
      for (CommonMasterProp commonMasterProp
          in _masterDataStructure._commonMasterProps) {
        // TODO: Can xu ly them.
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_prepareAllMasterDatas",
        error: "Error _prepareAllMasterDatas: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      error = true;
    }
    _prinStructureAndData();

    try {
      _lockFireChange = true;
      _formKey.currentState?.patchValue(data.currentFormData);
    } finally {
      _lockFireChange = false;
    }
    //
    if (error) {
      this.data._clearWithDataState(
            filterDataState: DataState.error,
          );
      return null;
    }

    //
    // Apply Default FilterCriteria:
    //
    // try {
    //   Map<String, dynamic> defaultFilterCriteria =
    //       this.initialCriteriaDataMap();
    //
    //   //
    //   if (_formKey.currentState == null) {
    //     this.data._updateFilterData(defaultFilterCriteria);
    //   } else {
    //     if (data._initialFormData.isEmpty) {
    //       this.data._updateFilterData(defaultFilterCriteria);
    //     }
    //     for (String key in defaultFilterCriteria.keys) {
    //       if (!_formKey.currentState!.instantValue.containsKey(key)) {
    //         _formKey.currentState!.patchValue(
    //           {key: defaultFilterCriteria[key]},
    //         );
    //       }
    //     }
    //   }
    // } catch (e, stackTrace) {
    //   _handleError(
    //     shelf: shelf,
    //     methodName: "filterInputToCriteriaDataMap",
    //     error: "Error filterInputToCriteriaDataMap: $e",
    //     stackTrace: stackTrace,
    //     showSnackBar: true,
    //   );
    //   error = true;
    // }
    //
    if (error) {
      this.data._clearWithDataState(
            filterDataState: DataState.error,
          );
      return null;
    }

    //
    // Apply FilterInput:
    //
    // if (filterInput != null) {
    //   try {
    //     Map<String, dynamic> inputFilterCriteria = filterInputToCriteriaDataMap(
    //       filterInput: filterInput,
    //     );
    //     //
    //     this.data._updateFilterData(inputFilterCriteria);
    //     this._formKey.currentState?.patchValue(inputFilterCriteria);
    //   } catch (e, stackTrace) {
    //     _handleError(
    //       shelf: shelf,
    //       methodName: "filterInputToCriteriaDataMap",
    //       error: "Error filterInputToCriteriaDataMap: $e",
    //       stackTrace: stackTrace,
    //       showSnackBar: true,
    //     );
    //     error = true;
    //   }
    //   //
    //   if (error) {
    //     this.data._clearWithDataState(
    //           filterDataState: DataState.error,
    //         );
    //     return null;
    //   }
    // }
    //
    try {
      // If no error:
      FILTER_CRITERIA newCriteria =
          createFilterCriteria(dataMap: data.currentFormData);
      _filterCriteria = newCriteria;
      //
      this.data._filterDataState = DataState.ready;
      _firstQueryDone = true;
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
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XList<dynamic, dynamic>?> prepareMasterPropDataForListType({
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

  Future<void> _prepareOptionedMasterDataCascade({
    required FILTER_INPUT? filterInput,
    required Object? parentMasterPropValue,
    required OptionedMasterProp optionedMasterProp,
  }) async {
    final String propName = optionedMasterProp.propName;

    switch (optionedMasterProp.type) {
      case OptionedMasterPropType.listable:
        // Get current MasterProp data:
        XList? xList = this.getMasterPropDataXList(propName);
        if (xList == null) {
          print("");
          //
          // Load OptionedMasterPro data from Rest API.
          // May throw ApiError.
          //
          xList = await prepareMasterPropDataForListType(
            filterInput: filterInput,
            parentMasterPropValue: parentMasterPropValue,
            propName: propName,
          );
        }
        //
        // IMPORTANT: Do not use empty list here
        // to avoid cast Error (List<dynamic> to List<ITEM>)
        //
        List? currentSelectedItems; // will be null or not empty.
        // Candidate Selected Items:
        List? candidateSelectedItems;
        if (xList != null) {
          MasterPropValueWrap? inputValueWrap;
          if (filterInput != null) {
            inputValueWrap = _filterInputToMasterPropValue(
              filterInput: filterInput,
              materPropData: xList,
              propName: propName,
            );
          }
          //
          // Current selected value:
          // It can be a single value or a List.
          //
          final dynamic currentValue = this.data.getProperty(propName);
          if (currentValue != null) {
            if (currentValue is List) {
              currentSelectedItems = currentValue.isEmpty ? null : currentValue;
            } else {
              currentSelectedItems = [currentValue];
            }
          }
          if (currentSelectedItems != null) {
            currentSelectedItems = xList.findItemsInListByDynamics(
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
        this.setMasterPropDataXList(
          propName: propName,
          xList: xList,
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
            this.data._updateFilterData({propName: candidateSelectedItems});
          } catch (e) {
            // IMPORTANT:
            //  - Update from ROOTs to LEAVES
            //  - And make sure children-OptionedMasterProp to null if parent-Value is null or not selected.
            Object? candidateSelectedItem = candidateSelectedItems.first;
            this.data._updateFilterData({propName: candidateSelectedItem});
          }
        } else {
          // IMPORTANT:
          //  - Update from ROOTs to LEAVES
          //  - And make sure children-OptionedMasterProp to null if parent-Value is null or not selected.
          this.data._updateFilterData({propName: null});
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
    Object? selectedMasterPropValue = this.data.getProperty(propName);
    if (selectedMasterPropValue != null) {
      for (OptionedMasterProp child in optionedMasterProp.children) {
        await _prepareOptionedMasterDataCascade(
          filterInput: filterInput,
          parentMasterPropValue: selectedMasterPropValue,
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

  ///
  /// This method is called after [prepareMasterData] and [initialCriteriaDataMap] methods.
  ///
  /// For example, after getting a list of companies from the [prepareMasterData] method.
  /// Use [FilterInput] to identify a company that will be used as a criterion for the filter.
  ///
  /// ```dart
  /// @override
  /// Map<String, dynamic> filterInputToCriteriaDataMap({
  ///    required CompanyIdFilterInput filterInput,
  /// }) {
  ///    int inputCompanyId = filterInput.filterInput;
  ///
  ///    CompanyInfo inputCompany = companyXList?.getItemById(inputCompanyId);
  ///    return {
  ///       "company": inputCompany,
  ///    };
  /// }
  /// ```
  ///
  @Deprecated("Khong su dung nua")
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required FILTER_INPUT filterInput,
  });

  MasterPropValueWrap? filterInputToMasterPropValue({
    required FILTER_INPUT filterInput,
    required XList materPropData,
    required String propName,
  });

  MasterPropValueWrap? _filterInputToMasterPropValue({
    required FILTER_INPUT filterInput,
    required XList materPropData,
    required String propName,
  }) {
    MasterPropValueWrap? wrap = filterInputToMasterPropValue(
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
  Future<void> _onChangeFromFilterView() async {
    print("@~~~~~~~~~~~~~~~> ## _onChangeFromFilterView");
    //
    // IMPORTANT:
    // Update data from GlobalKey(_formKey) --> to FilterModelData.
    //  ---> data._currentFormData
    //  ---> data._initialFormData
    //
    if (_formKey.currentState?.instantValue != null) {
      if (data._justInitialized) {
        Map<String, dynamic> map = {..._formKey.currentState!.instantValue};
        map.removeWhere((k, v) => data._initialFormData.containsKey(k));
        //
        data._initialFormData.addAll(map);
      }
      //
      // IMPORTANT: Will execute XList Event.
      //
      data._updateFilterData(_formKey.currentState!.instantValue);
    }
    //
    if (_firstQueryDone) {
      if (!_applyDefaultFilterCriteria) {
        if (_formKey.currentState != null) {
          _applyDefaultFilterCriteria = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // _formKey.currentState!.patchValue(data.initialFormData);
          });
        }
      }
      //
      await _prepareAllMasterPropDataAndFilterData(
        filterInput: null,
      );
    }
    this.updateAllUIComponents(force: true);
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
    data._justInitialized = false;
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
}
