part of '../../flutter_artist.dart';

abstract class FilterModel<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _XBase {
  @override
  late final Shelf shelf;

  late final String name;

  String get id {
    return "filter-model > ${shelf.name} > $name";
  }

  final List<Block> _blocks = [];

  List<Block> get blocks => [..._blocks];

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => [..._scalars];

  FILTER_CRITERIA? _filterCriteria;

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  bool _defaultValueInitiated = false;

  bool _lockAddMoreQuery = false;

  bool get lockAddMoreQuery => _lockAddMoreQuery;

  late final FilterCriteriaStructure _filterCriteriaStructure;

  DataState? get filterDataState => _filterCriteriaStructure._filterDataState;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // ***************************************************************************
  // ***************************************************************************

  FilterModel() {
    __registerCriteriaStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// FilterCriteriaStructure registerCriteriaStructure() {
  ///   return FilterCriteriaStructure(
  ///     simpleCriteria: [],
  ///     multiOptCriteria: [
  ///       MultiOptCriterion(
  ///         criterionName: "company",
  ///         children: [
  ///           MultiOptCriterion(
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

  ///
  /// Abstract method:
  ///
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required FILTER_INPUT? filterInput,
    required Object? parentMultiOptCriterionValue,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues();

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  ///
  /// This method is called after [prepareMasterData] method.
  ///
  /// For example, after getting a list of companies from the [prepareMasterData] method.
  /// Use [FilterInput] to identify a company that will be used as a criterion for the filter.
  ///
  /// ```dart
  /// @override
  /// ValueWrap? getMultiOptCriterionValueFromFilterInput({
  ///     required String multiOptCriterionName,
  ///     required ExampleFilterInput filterInput,
  ///     required XData multiOptCriterionXData,
  ///     required Object? parentMultiOptCriterionValue,
  /// }) {
  ///    if(multiOptCriterionName == "company") {
  ///       int inputCompanyId = filterInput.filterInput;
  ///       CompanyInfo? inputCompany = materPropData?.getItemById(inputCompanyId);
  ///       return MasterPropValueWrap([inputCompany])
  ///    }
  ///    return null;
  /// }
  /// ```
  ///
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required XData multiOptCriterionXData,
    required FILTER_INPUT filterInput,
    required Object? parentMultiOptCriterionValue,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  Future<Map<String, dynamic>?> getSimpleCriterionValuesFromFilterInput({
    required FILTER_INPUT filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitFilterViewChanged({
    required _XFilterModel xFilterModel,
  }) async {
    __assertThisXFilterModel(xFilterModel);
    //
    _filterCriteriaStructure._setFilterDataState(DataState.pending);
    //
    FILTER_CRITERIA? filterCriteria = await _startNewFilterActivity(
      activityType: _FilterActivityType.updateFromFilterView,
      filterInput: null,
    );
    return filterCriteria != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __registerCriteriaStructure() {
    try {
      _filterCriteriaStructure = registerCriteriaStructure();
      _filterCriteriaStructure.filterModel = this;
    } on _DuplicateFilterCriterionException catch (e) {
      String message =
          "Duplicate criterion '${e.criterionName}' in ${getClassName(this)}";
      throw _createFatalAppError(message);
    } on _FilterCriterionCycleError catch (e) {
      String message = '''
         The parent-child relationship of several criteria forms a cycle.
         ┌─────┐
         |  ${e.criterionName1}
         ↑     ↓
         |  ${e.criterionName2}
         └─────┘
         Double check class ${getClassName(this)}.
       ''';
      throw _createFatalAppError(message);
    } catch (e, stackTrace) {
      print(stackTrace);
      String message = "Unknown Error $e in ${getClassName(this)}";
      throw _createFatalAppError(message);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename?
  Map<String, dynamic> get initialCriteriaValues {
    return _filterCriteriaStructure._initialCriteriaValues;
  }

  // TODO: Rename?
  Map<String, dynamic> get criteriaValues {
    return _filterCriteriaStructure._currentCriteriaValues;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return _filterCriteriaStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getCriterionValue(String criterionName) {
    return _filterCriteriaStructure._getCurrentCriterionValue(
      criterionName: criterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? getMultiOptCriterionXData(String multiOptCriterionName) {
    return _filterCriteriaStructure._getMultiOptCriterionXData(
      multiOptCriterionName,
    );
  }

  dynamic getMultiOptCriterionData(String multiOptCriterionName) {
    XData? multiOptCriterionXData = getMultiOptCriterionXData(
      multiOptCriterionName,
    );
    //
    dynamic data = multiOptCriterionXData?.data;
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
  Future<FILTER_CRITERIA?> _startNewFilterActivity({
    required FILTER_INPUT? filterInput,
    required _FilterActivityType activityType,
  }) async {
    print("#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFilterActivity");

    // if (activityType == _FilterDataAction.newFilt) {
    //   _defaultValueInitiated = false;
    // }

    final Map<String, dynamic> formKeyInstantValues =
        _formKey.currentState?.instantValue ?? {};

    //
    _filterCriteriaStructure._initTemporaryForNewTransaction(
      activityType: activityType,
      formKeyInstantValues: formKeyInstantValues,
      filterInput: filterInput,
    );
    //
    // Load OptProp Data:
    //
    try {
      for (MultiOptCriterion multiOptCriterion
          in _filterCriteriaStructure._rootOptCriteria) {
        //
        // Load OptCriterion Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadMultiOptCriterionDataCascade(
          filterInput: filterInput,
          parentMultiOptCriterionValue: null,
          multiOptCriterion: multiOptCriterion,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiLoadMultiOptCriterionXData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      _filterCriteriaStructure._setFilterDataState(DataState.error);
      _filterCriteria = null;
      return _filterCriteria;
    }
    //
    if (filterInput != null) {
      try {
        Map<String, dynamic> simpleValues =
            await getSimpleCriterionValuesFromFilterInput(
                  filterInput: filterInput,
                ) ??
                {};
        for (String criterionName in simpleValues.keys) {
          dynamic value = simpleValues[criterionName];
          _filterCriteriaStructure._setTempSimpleCriterionValue(
            criterionName: criterionName,
            value: value,
          );
        }
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "getSimpleCriterionValuesFromFilterInput",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        _filterCriteriaStructure._setFilterDataState(DataState.error);
        _filterCriteria = null;
        return _filterCriteria;
      }
    } else {
      try {
        if (!_defaultValueInitiated) {
          Map<String, dynamic> defaultValues =
              await specifyDefaultSimpleCriterionValues() ?? {};

          for (String criterionName in defaultValues.keys) {
            dynamic value = defaultValues[criterionName];
            _filterCriteriaStructure._setTempSimpleCriterionValue(
              criterionName: criterionName,
              value: value,
            );
          }
        }
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "specifyDefaultSimpleCriterionValues",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        _filterCriteriaStructure._setFilterDataState(DataState.error);
        _filterCriteria = null;
        return _filterCriteria;
      }
    }
    //
    try {
      // Convert Map Data to FilterCriteria Object.
      FILTER_CRITERIA newCriteria = toFilterCriteriaObject(
        dataMap: _filterCriteriaStructure._tempCriteriaValues,
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
        newCurrentValue: _filterCriteriaStructure._currentCriteriaValues,
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
        methodName: "toFilterCriteriaObject",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      _filterCriteriaStructure._setFilterDataState(DataState.error);
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterCriteriaStructure._currentCriteriaValues,
      );
      //
      _filterCriteria = null;
      return _filterCriteria;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptCriterionDataCascade({
    required FILTER_INPUT? filterInput,
    required Object? parentMultiOptCriterionValue,
    required MultiOptCriterion multiOptCriterion,
    required Map<String, dynamic> formKeyInstantValues,
    required _FilterActivityType activityType,
  }) async {
    final String multiOptCriterionName = multiOptCriterion.criterionName;

    final MultiOptCriterion? multiOptCriterionParent = multiOptCriterion.parent;

    // Get current OptCriterion data:
    XData? tempMultiOptCriterionXData =
        _filterCriteriaStructure._getTempMultiOptCriterionXData(
      multiOptCriterionName,
    );
    final dynamic tempCurrentMultiOptValue = _filterCriteriaStructure
        ._getTempCurrentCriterionValue(criterionName: multiOptCriterionName);

    //
    dynamic newSelectedValue =
        _filterCriteriaStructure._getTempCurrentCriterionValue(
      criterionName: multiOptCriterionName,
    );
    if (activityType == _FilterActivityType.updateFromFilterView) {
      if (formKeyInstantValues.containsKey(multiOptCriterionName)) {
        newSelectedValue = formKeyInstantValues[multiOptCriterionName];
      }
    }
    //
    final bool valueChanged;
    if (tempMultiOptCriterionXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempMultiOptCriterionXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    //
    multiOptCriterion._tempCurrentValue = newSelectedValue;
    //
    if (valueChanged) {
      _filterCriteriaStructure._updateChildrenMultiOptValueToNullCascade(
        multiOptCriterion: multiOptCriterion,
      );
    }
    //
    if (multiOptCriterionParent != null) {
      XData? tempMultiOptXDataParent =
          _filterCriteriaStructure._getTempOptCriterionXData(
        multiOptCriterionParent.criterionName,
      );
      //
      if (tempMultiOptXDataParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptCriterionValueOLD =
            _filterCriteriaStructure._getCurrentCriterionValue(
          criterionName: multiOptCriterionParent.criterionName,
        );
        // Parent Value change?
        bool isSame = tempMultiOptXDataParent.isSameItemOrItemList(
          itemOrItemList1: parentOptCriterionValueOLD,
          itemOrItemList2: parentMultiOptCriterionValue,
        );
        if (!isSame) {
          tempMultiOptCriterionXData = null;
        }
      } else {
        tempMultiOptCriterionXData = null;
      }
    }
    //
    if (tempMultiOptCriterionXData == null) {
      _filterCriteriaStructure._setTempMultiOptCriterionXData(
        multiOptCriterionName: multiOptCriterionName,
        multiOptXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterCriteriaStructure._updateCriteriaTempValues({
        multiOptCriterionName: null,
      });
    }
    //
    // Load OptCriterion data from Rest API.
    // May throw ApiError.
    //
    tempMultiOptCriterionXData ??= await callApiLoadMultiOptCriterionXData(
      filterInput: filterInput,
      parentMultiOptCriterionValue: parentMultiOptCriterionValue,
      multiOptCriterionName: multiOptCriterionName,
    );
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    if (tempMultiOptCriterionXData != null) {
      ValueWrap? inputValueWrap;
      if (filterInput != null) {
        inputValueWrap = __getMultiOptCriterionValueFromFilterInput(
          filterInput: filterInput,
          parentMultiOptCriterionValue: parentMultiOptCriterionValue,
          multiOptCriterionXData: tempMultiOptCriterionXData,
          multiOptCriterionName: multiOptCriterionName,
        );
      } else {
        if (!_defaultValueInitiated) {
          inputValueWrap = __specifyDefaultMultiOptCriterionValue(
            parentMultiOptCriterionValue: parentMultiOptCriterionValue,
            multiOptCriterionXData: tempMultiOptCriterionXData,
            multiOptCriterionName: multiOptCriterionName,
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _filterCriteriaStructure._getTempCurrentCriterionValue(
        criterionName: multiOptCriterionName,
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
            tempMultiOptCriterionXData._findInternalItemsByDynamics(
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
    _filterCriteriaStructure._setTempMultiOptCriterionXData(
      multiOptCriterionName: multiOptCriterionName,
      multiOptXData: tempMultiOptCriterionXData,
    );
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (multiOptCriterion.singleSelection) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _filterCriteriaStructure._updateCriteriaTempValues({
          multiOptCriterionName: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _filterCriteriaStructure._updateCriteriaTempValues({
          multiOptCriterionName: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterCriteriaStructure._updateCriteriaTempValues({
        multiOptCriterionName: null,
      });
    }
    //
    Object? tempSelectedCriterionValue =
        _filterCriteriaStructure._getTempCurrentCriterionValue(
      criterionName: multiOptCriterionName,
    );

    if (tempSelectedCriterionValue != null) {
      for (MultiOptCriterion child in multiOptCriterion.children) {
        await _loadMultiOptCriterionDataCascade(
          filterInput: filterInput,
          parentMultiOptCriterionValue: tempSelectedCriterionValue,
          multiOptCriterion: child,
          activityType: activityType,
          formKeyInstantValues: formKeyInstantValues,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createNullValueWrapAppException({
    required String methodName,
    required String multiOptCriterionName,
  }) {
    MultiOptCriterion? multiOptCriterion =
        _filterCriteriaStructure._getMultiOptCriterion(multiOptCriterionName);
    if (multiOptCriterion == null) {
      throw "The '$multiOptCriterionName' is not $MultiOptCriterion";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $ValueWrap for the multiOptCriterionName '$multiOptCriterionName'. ";
    if (multiOptCriterion.singleSelection) {
      message += "$ValueWrap.single(null) or $ValueWrap.single(value). ";
    } else {
      message += "$ValueWrap.multi([null]) or $ValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptCriterion. See the specification of this method for more information.";
    // throw AppException(message: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? __getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required XData multiOptCriterionXData,
    required FILTER_INPUT filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    ValueWrap? valueWrap = getMultiOptCriterionValueFromFilterInput(
      filterInput: filterInput,
      parentMultiOptCriterionValue: parentMultiOptCriterionValue,
      multiOptCriterionXData: multiOptCriterionXData,
      multiOptCriterionName: multiOptCriterionName,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppException(
        methodName: "getMultiOptCriterionValueFromFilterInput",
        multiOptCriterionName: multiOptCriterionName,
      );
    }
    List? value = valueWrap?.values ?? [];
    return ValueWrap.multi(
      multiOptCriterionXData._findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: false,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  ValueWrap? __specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    ValueWrap? valueWrap = specifyDefaultMultiOptCriterionValue(
      parentMultiOptCriterionValue: parentMultiOptCriterionValue,
      multiOptCriterionXData: multiOptCriterionXData,
      multiOptCriterionName: multiOptCriterionName,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppException(
        methodName: "specifyDefaultMultiOptCriterionValue",
        multiOptCriterionName: multiOptCriterionName,
      );
    }
    List? value = valueWrap?.values ?? [];
    return ValueWrap.multi(
      multiOptCriterionXData._findInternalItemsByDynamics(
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
  /// calling [callApiLoadMultiOptCriterionXData]
  /// methods if there are no errors.
  ///
  FILTER_CRITERIA toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Used for FilterView.
  ///
  Map<String, dynamic> _initialValuesForFilterView() {
    return _filterCriteriaStructure._currentCriteriaValues;
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
    return "<${getFilterInputType()}, ${getFilterCriteriaType()}>";
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  Type getFilterInputType() {
    return FILTER_INPUT;
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
                forceQuery: true,
                forceReloadItem: false,
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
      shelf._startLoadDataForLazyUIComponentsIfNeed();
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
