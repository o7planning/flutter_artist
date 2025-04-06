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
  final Map<int, FILTER_CRITERIA> __filterCriteriaMap = {};

  FILTER_CRITERIA? get currentSuccessFilterCriteria {
    return __currentSuccessCriteriaId == null
        ? null
        : __filterCriteriaMap[__currentSuccessCriteriaId];
  }

  FILTER_CRITERIA? _filterCriteria;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  bool _defaultValueInitiated = false;

  late final FilterCriteriaStructure _filterCriteriaStructure;

  bool _lockAddMoreQuery = false;

  bool get lockAddMoreQuery => _lockAddMoreQuery;

  // ***************************************************************************
  // ***************************************************************************

  FilterModel() {
    __registerCriteriaStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitFilterViewChanged({
    required _XFilterModel xFilterModel,
  }) async {
    __assertThisXFilterModel(xFilterModel);
    //
    _filterCriteriaStructure._setFilterDataState(DataState.pending);
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
  /// FilterCriteriaStructure registerCriteriaStructure() {
  ///   return FilterCriteriaStructure(
  ///     simpleCriteria: [],
  ///     optCriteria: [
  ///       OptCriterion(
  ///         criterionName: "company",
  ///         children: [
  ///           OptCriterion(
  ///              criterionName: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  FilterCriteriaStructure registerCriteriaStructure();

  // ***************************************************************************
  // ***************************************************************************

  void __registerCriteriaStructure() {
    _filterCriteriaStructure = registerCriteriaStructure();
    _filterCriteriaStructure.filterModel = this;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get initialFormData {
    return _filterCriteriaStructure.initialFormData;
  }

  Map<String, dynamic> get currentFormData {
    return _filterCriteriaStructure.currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return _filterCriteriaStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getCurrentCriterionValue(String criterionName) {
    return _filterCriteriaStructure._getCurrentCriterionValue(
      criterionName: criterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XOptionedData? getOptCriterionXData(String criterionName) {
    return _filterCriteriaStructure._getOptCriterionXData(criterionName);
  }

  dynamic getOptCriterionData(String criterionName) {
    XOptionedData? optCriterionData = getOptCriterionXData(criterionName);
    dynamic data = optCriterionData?.data;
    if (data != null) {
      return data;
    } else {
      return data;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printStructureAndTempData(String prefix) {
    _filterCriteriaStructure._printTemporaryInfo(prefix);
  }

  // ***************************************************************************
  // ***************************************************************************

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
    print("#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFilterTransaction");
    try {
      // All values including hidden values (not on the user interface).
      Map<String, dynamic> allNewValue = {
        ..._filterCriteriaStructure.currentFormData
      };
      // Update values from view (On the user Interface).
      allNewValue.addAll(_formKey.currentState?.instantValue ?? {});
      //
      _filterCriteriaStructure._initTemporaryForNewTransaction(
        newCurrentFormData: filterInput != null
            ? {} // To Clear All.
            : allNewValue,
      );
      _filterCriteriaStructure._printTemporaryInfo("@1");
      //
      for (OptCriterion optCriterion
          in _filterCriteriaStructure._rootOptCriteria) {
        //
        // Load OptCriterion Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadOptCriterionDataCascade(
          filterInput: filterInput,
          parentOptCriterionValue: null,
          optCriterion: optCriterion,
        );
      }
      //
      _filterCriteriaStructure._printTemporaryInfo("@2");
      //
      if (filterInput != null) {
        for (SimpleCriterion simpleCriterion
            in _filterCriteriaStructure._simpleCriteria) {
          Object? value = getSimpleCriterionValueFromFilterInput(
            filterInput: filterInput,
            criterionName: simpleCriterion.criterionName,
          );
          _filterCriteriaStructure._setTempSimpleCriterionValue(
            criterionName: simpleCriterion.criterionName,
            value: value,
          );
        }
      } else {
        if (!_defaultValueInitiated) {
          for (SimpleCriterion simpleCriterion
              in _filterCriteriaStructure._simpleCriteria) {
            Object? value = specifyDefaultSimpleCriterionValue(
              criterionName: simpleCriterion.criterionName,
            );
            _filterCriteriaStructure._setTempSimpleCriterionValue(
              criterionName: simpleCriterion.criterionName,
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
      _filterCriteriaStructure._setFilterDataState(DataState.error);
      _filterCriteria = null;
      return _filterCriteria;
    }
    //
    _printStructureAndTempData("@3");
    //
    try {
      // Convert Map Data to FilterCriteria Object.
      FILTER_CRITERIA newCriteria = createFilterCriteria(
        dataMap: _filterCriteriaStructure.tempCurrentFormData,
      );
      _filterCriteria = newCriteria;
      //
      // Update Real FromData from Temporary FormData:
      //
      _filterCriteriaStructure._updateTempToReal();
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterCriteriaStructure.currentFormData,
      );
      //
      _defaultValueInitiated = true;
      _filterCriteriaStructure._setFilterDataState(DataState.ready);
      //
      _filterCriteria = newCriteria;
      return _filterCriteria;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "createFilterCriteria",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      _filterCriteriaStructure._setFilterDataState(DataState.error);
      //
      // IMPORTANT: Restore OLD State:
      // Note [_formKeyPatchValue] NOT WORK!.
      //
      _formKeyPatchValue(
        newCurrentValue: _filterCriteriaStructure.currentFormData,
      );
      //
      _filterCriteria = null;
      return _filterCriteria;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XOptionedData?> callApiLoadOptCriterionData({
    required FILTER_INPUT? filterInput,
    required Object? parentOptCriterionValue,
    required String criterionName,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadOptCriterionDataCascade({
    required FILTER_INPUT? filterInput,
    // May be new selected parent value.
    required Object? parentOptCriterionValue,
    required OptCriterion optCriterion,
  }) async {
    final String criterionName = optCriterion.criterionName;

    final OptCriterion? optCriterionParent = optCriterion.parent;

    // Get current OptCriterion data:
    XOptionedData? optCriterionData =
        _filterCriteriaStructure._getOptCriterionXData(criterionName);

    if (optCriterionParent != null) {
      XOptionedData? tempXOptionedParent =
          _filterCriteriaStructure._getTempOptCriterionXData(
        optCriterionParent.criterionName,
      );
      //
      if (tempXOptionedParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptCriterionValueOLD =
            _filterCriteriaStructure._getCurrentCriterionValue(
          criterionName: optCriterionParent.criterionName,
        );

        // Parent Value change?
        bool isSame = tempXOptionedParent.isSameItemOrItemList(
          itemOrItemList1: parentOptCriterionValueOLD,
          itemOrItemList2: parentOptCriterionValue,
        );
        if (!isSame) {
          optCriterionData = null;
        }
      } else {
        optCriterionData = null;
      }
    }
    //
    if (optCriterionData == null) {
      _filterCriteriaStructure._setTempOptCriterionXData(
        criterionName: criterionName,
        optionedXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterCriteriaStructure._updateCriteriaTempValues({
        criterionName: null,
      });
    }
    //
    // Load OptCriterion data from Rest API.
    // May throw ApiError.
    //
    optCriterionData ??= await callApiLoadOptCriterionData(
      filterInput: filterInput,
      parentOptCriterionValue: parentOptCriterionValue,
      criterionName: criterionName,
    );
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    if (optCriterionData != null) {
      PropValue? inputValueWrap;
      if (filterInput != null) {
        inputValueWrap = _getOptCriterionValueFromFilterInput(
          filterInput: filterInput,
          optCriterionData: optCriterionData,
          criterionName: criterionName,
        );
      } else {
        if (!_defaultValueInitiated) {
          inputValueWrap = __specifyDefaultOptCriterionValue(
            optCriterionData: optCriterionData,
            criterionName: criterionName,
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _filterCriteriaStructure._getTempCurrentCriterionValue(
        criterionName: criterionName,
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
        currentSelectedItems = optCriterionData.findInternalItemsByDynamics(
          dynamicValues: currentSelectedItems,
          removeCurrentNotFoundItems: true,
          addToInternalIfNotFound: false,
        );
      }
      // Candidate Selected Items:
      candidateSelectedItems = inputValueWrap?.values;

      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    } else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }
    //
    _filterCriteriaStructure._setTempOptCriterionXData(
      criterionName: criterionName,
      optionedXData: optCriterionData,
    );
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (optCriterion.singleSelection) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _filterCriteriaStructure._updateCriteriaTempValues({
          criterionName: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _filterCriteriaStructure._updateCriteriaTempValues({
          criterionName: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterCriteriaStructure._updateCriteriaTempValues({
        criterionName: null,
      });
    }
    //
    Object? tempSelectedCriterionValue =
        _filterCriteriaStructure._getTempCurrentCriterionValue(
      criterionName: criterionName,
    );

    if (tempSelectedCriterionValue != null) {
      for (OptCriterion child in optCriterion.children) {
        await _loadOptCriterionDataCascade(
          filterInput: filterInput,
          parentOptCriterionValue: tempSelectedCriterionValue,
          optCriterion: child,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Object? getSimpleCriterionValueFromFilterInput({
    required FILTER_INPUT filterInput,
    required String criterionName,
  });

  ///
  /// This method is called after [prepareMasterData] method.
  ///
  /// For example, after getting a list of companies from the [prepareMasterData] method.
  /// Use [FilterInput] to identify a company that will be used as a criterion for the filter.
  ///
  /// ```dart
  /// @override
  /// MasterPropValueWrap? getOptCriterionValueFromFilterInput({
  ///     required ExampleFilterInput filterInput,
  ///     required XOptionedData optCriterionData,
  ///     required String criterionName,
  /// }) {
  ///    if(criterionName == "company") {
  ///       int inputCompanyId = filterInput.filterInput;
  ///       CompanyInfo? inputCompany = materPropData?.getItemById(inputCompanyId);
  ///       return MasterPropValueWrap([inputCompany])
  ///    }
  ///    return null;
  /// }
  /// ```
  ///
  PropValue? getOptCriterionValueFromFilterInput({
    required FILTER_INPUT filterInput,
    required XOptionedData optCriterionData,
    required String criterionName,
  });

  PropValue? specifyDefaultOptCriterionValue({
    required XOptionedData optCriterionData,
    required String criterionName,
  });

  Object? specifyDefaultSimpleCriterionValue({
    required String criterionName,
  });

  PropValue? _getOptCriterionValueFromFilterInput({
    required FILTER_INPUT filterInput,
    required XOptionedData optCriterionData,
    required String criterionName,
  }) {
    PropValue? wrap = getOptCriterionValueFromFilterInput(
      filterInput: filterInput,
      optCriterionData: optCriterionData,
      criterionName: criterionName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.values;
    return PropValue.multi(
      optCriterionData.findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: false,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  PropValue? __specifyDefaultOptCriterionValue({
    required XOptionedData optCriterionData,
    required String criterionName,
  }) {
    PropValue? wrap = specifyDefaultOptCriterionValue(
      optCriterionData: optCriterionData,
      criterionName: criterionName,
    );
    if (wrap == null) {
      return null;
    }
    List? value = wrap.values;
    return PropValue.multi(
      optCriterionData.findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: false,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called immediately after
  /// calling [callApiLoadOptCriterionData]
  /// methods if there are no errors.
  ///
  FILTER_CRITERIA createFilterCriteria({
    required Map<String, dynamic> dataMap,
  });

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Change name!
  Map<String, dynamic> _initFilterValue() {
    return _filterCriteriaStructure.currentFormData;
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
