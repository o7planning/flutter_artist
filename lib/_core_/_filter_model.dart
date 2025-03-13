part of '../flutter_artist.dart';

typedef FindXList = XList? Function();

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

  bool _firstQueryDone = false;
  bool _applyDefaultFilterCriteria = false;

  // @Deprecated("Xoa di, khong su dung nua")
  // final _PropTreeBuilder __propTreeBuilder = _PropTreeBuilder();
  // @Deprecated("Xoa di, khong su dung nua")
  // late final _PropTree _propTree;

  // final Map<String, XList> _xListMap = {};

  late final MasterProperties _masterProperties;

  // ***************************************************************************
  // ***************************************************************************

  FilterModel() {
    __initMasterProperties();
    // setupPropertyConstraints();
    // _propTree = __propTreeBuilder.build();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initMasterProperties() {
    List<MasterProperty> materProperties = registerMasterProperties();
    this._masterProperties = MasterProperties(
      masterProperties: materProperties,
    );
  }

  ///
  /// ```dart
  /// List<MasterProperty> registerMasterProperties() {
  ///     return [
  ///        MasterProperty(
  ///           propName: "company",
  ///           children: [
  ///              MasterProperty(
  ///                 propName: "department",
  ///              ),
  ///           ],
  ///        ),
  ///     ];
  ///   }
  /// ```
  List<MasterProperty> registerMasterProperties() {
    return [];
  }

  // ***************************************************************************
  // ***************************************************************************

  XList? getXList(String propertyName) {
    return _masterProperties.getXList(propertyName);
  }

  // ***************************************************************************
  // ***************************************************************************

  void setXList({required String property, required XList? xList}) {
    _masterProperties.setXList(property: property, xList: xList);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  Future<FILTER_CRITERIA?> _prepareMasterDataAndFilterData({
    required FILTER_INPUT? filterInput,
  }) async {
    bool error = false;
    try {
      //
      // May throw ApiError.
      //
      await prepareMasterData(
        filterInput: filterInput,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareMasterData",
        error: "Error prepareMasterData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      error = true;
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
    try {
      Map<String, dynamic> defaultFilterCriteria =
          this.initialCriteriaDataMap();

      //
      if (_formKey.currentState == null) {
        this.data._updateFilterData(defaultFilterCriteria);
      } else {
        if (data._initialFormData.isEmpty) {
          this.data._updateFilterData(defaultFilterCriteria);
        }
        for (String key in defaultFilterCriteria.keys) {
          if (!_formKey.currentState!.instantValue.containsKey(key)) {
            _formKey.currentState!.patchValue(
              {key: defaultFilterCriteria[key]},
            );
          }
        }
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "filterInputToCriteriaDataMap",
        error: "Error filterInputToCriteriaDataMap: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      error = true;
    }
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
    if (filterInput != null) {
      try {
        Map<String, dynamic> inputFilterCriteria = filterInputToCriteriaDataMap(
          filterInput: filterInput,
        );
        //
        this.data._updateFilterData(inputFilterCriteria);
        this._formKey.currentState?.patchValue(inputFilterCriteria);
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "filterInputToCriteriaDataMap",
          error: "Error filterInputToCriteriaDataMap: $e",
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        error = true;
      }
      //
      if (error) {
        this.data._clearWithDataState(
              filterDataState: DataState.error,
            );
        return null;
      }
    }
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
  /// Call this method to initialize the necessary data for the FilterModel.
  /// For example, the list of items of the [Dropdown].
  ///
  /// This method is called before [filterInputToCriteriaDataMap] method.
  ///
  /// Example:
  /// ```dart
  /// Future<void> prepareMasterData({
  ///     required EmptyFilterInput? filterInput,
  /// }) {
  ///   ApiResult<CompanyPage> result1 = await companyApi.getCompanyPage();
  ///   // Throw ApiError
  ///   result1.throwIfError();
  ///   this.companyXList = result1.data?.toXList();
  ///   CompanyInfo? company = this.companyXList.getItemById(123)
  ///
  ///   ApiResult<DepartmentPage> result2 = await deptApi.getDepartmentPage(company);
  ///   // Throw ApiError
  ///   result2.throwIfError();
  ///   this.departmentXList = result2.data?.toXList();
  ///   ...
  /// }
  /// ```
  ///
  Future<void> prepareMasterData({
    required FILTER_INPUT? filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called after [prepareMasterData].
  ///
  /// Use the data obtained from the [prepareMasterData] method to specify default search criteria.
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
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required FILTER_INPUT filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called immediately after calling [prepareData()] method if there are no errors.
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
            // ????????????????????????????
            // _formKey.currentState!.patchValue(data.initialFormData);
          });
        }
      }
      //
      await _prepareMasterDataAndFilterData(
        // ?????????????????????????????????????????????????????????????????????????????????????????
        filterInput: null, // TODO: Xem lai tham so filterInput.
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
        widgetState._lockChangeEvent = true;
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
