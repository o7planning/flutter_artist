part of '../flutter_artist.dart';

abstract class DataFilter<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _XBase {
  late final Shelf shelf;

  late final String name;

  String get id {
    return "data-filter > ${shelf.name} > $name";
  }

  final List<Block> _blocks = [];

  List<Block> get blocks => [..._blocks];

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => [..._scalars];

  int __currentTryingCriteriaId = 0;
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

  late final DataFilterData data = DataFilterData(dataFilter: this);
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  List<Restorable> get restorableCriteria;

  // ***************************************************************************
  // ***************************************************************************

  DataFilter();

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
      await prepareMasterFilterData(
        filterInput: filterInput,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareMasterFilterData",
        error: "Error prepareMasterFilterData: $e",
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
      return null;
    }
    //
    if (filterInput != null) {
      Map<String, dynamic> newFilterData = {};
      try {
        newFilterData = prepareFilterData(
          filterInput: filterInput,
        );
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "prepareFilterData",
          error: "Error prepareFilterData: $e",
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
        return null;
      }
      //
      try {
        this.data._updateFilterData(newFilterData);
        this._formKey.currentState?.patchValue(newFilterData);
        //
        updateAllUIComponents();
      } catch (e, stackTrace) {
        error = true;
        //
        _handleError(
          shelf: shelf,
          methodName: "_updateFilterData",
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
        return null;
      }
    }
    //
    Map<String, dynamic> instantValue =
        _formKey.currentState?.instantValue ?? {};
    try {
      // If no error:
      FILTER_CRITERIA newCriteria = createFilterCriteria(dataMap: instantValue);
      _filterCriteria = newCriteria;
      //
      return newCriteria;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "createFilterCriteria",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return null;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Call this method to initialize the necessary data for the DataFilter.
  /// For example, the list of items of the [Dropdown].
  ///
  /// This method is called before [prepareFilterData] method.
  ///
  /// Example:
  /// ```dart
  /// Future<void> prepareMasterFilterData({
  ///     required EmptyFilterInput? filterInput,
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
  Future<void> prepareMasterFilterData({
    required FILTER_INPUT? filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called after [prepareMasterFilterData].
  ///
  Map<String, dynamic> prepareFilterData({
    required FILTER_INPUT? filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Change name!
  // Do not call this method in library.
  Map<String, dynamic> initFilterValue() {
    return data._currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  void _onChangeFromFilterView() {
    print("_onChangeFromFilterView: ${_formKey.currentState?.instantValue}");
    if (_formKey.currentState?.instantValue != null) {
      data._currentFormData.addAll(_formKey.currentState!.instantValue);
      if (data._justInitialized) {
        data._initialFormData.addAll(_formKey.currentState!.instantValue);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  final Map<_RefreshableWidgetState, bool> _filterFragmentWidgetStates = {};

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
  /// This method is called immediately after calling [prepareData()] method if there are no errors.
  ///
  FILTER_CRITERIA createFilterCriteria({
    required Map<String, dynamic> dataMap,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```Dart
  /// Future<void> prepareData({MyFilterInput? filterInput}) {
  ///     ApiResult<dynamic>? r1 = await callYourApi1();
  ///     // Throws ApiError if r1.isError()
  ///     r1?.throwIfError();
  ///
  ///     ApiResult<dynamic>? r2 = await callYourApi2();
  ///     // Throws ApiError if r2.isError()
  ///     r2?.throwIfError();
  /// }
  /// ```
  ///
  @Deprecated("Xoa di, khong su dung nua")
  Future<void> prepareData({
    FILTER_INPUT? filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query all Scalars and Blocks of this DataFilter if they are visible on the UI.
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
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: this,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: _scalars.map((s) => _ScalarOpt(scalar: s)).toList(),
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
      forceQueryBlockFormOpts: [],
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
      bool isShowing = _filterFragmentWidgetStates[widgetState] ?? false;
      if (isShowing && widgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addFilterFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _filterFragmentWidgetStates[widgetState] = isShowing;
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

  void updateAllUIComponents() {
    for (_RefreshableWidgetState widgetState in [
      ..._filterFragmentWidgetStates.keys
    ]) {
      print("Chay vao day@: ${_filterFragmentWidgetStates.length}");
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }
}
