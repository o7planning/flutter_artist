part of '../core.dart';

class FilterModelStructure {
  final ConditionConnector connector;
  final List<ConditionDef> conditions;
  //
  final Map<String, FilterCriterionModel> _allCriteriaMap = {};
  final List<MultiOptFilterCriterionModel> _rootOptCriteria;
  final List<SimpleFilterCriterionModel> _simpleCriteria = [];
  final List<CalculatedFilterCriterionModel> _calculatedCriteria = [];

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  FilterModelStructure({
    required List<SimpleFilterCriterionModel> simpleCriteria,
    required List<MultiOptFilterCriterionModel> multiOptCriteria,
    List<CalculatedFilterCriterionModel> calculatedCriteria = const [],
    //
    required this.connector,
    required this.conditions,
  }) : _rootOptCriteria = List.unmodifiable(multiOptCriteria) {
    for (MultiOptFilterCriterionModel rootOptCriterion in multiOptCriteria) {
      __standardizeCascade(rootOptCriterion, null);
    }
    for (SimpleFilterCriterionModel sc in simpleCriteria) {
      if (_allCriteriaMap.containsKey(sc.criterionNameX)) {
        throw DuplicateFilterCriterionError(
          criterionNameX: sc.criterionNameX,
        );
      }
      __initSimpleCriterion(
        newSimpleCriterion: sc,
        markTempDirty: false,
      );
    }
    for (CalculatedFilterCriterionModel cc in calculatedCriteria) {
      if (_allCriteriaMap.containsKey(cc.criterionNameX)) {
        throw DuplicateFilterCriterionError(
          criterionNameX: cc.criterionNameX,
        );
      }
      __initCalculatedCriterion(
        newCalculatedCriterion: cc,
        markTempDirty: false,
      );
    }
    //
    for (ConditionDef conditionDef in conditions) {
      __initConditionCascade(
        conditionDef: conditionDef,
        parentGroup: null,
      );
    }
  }

  void __initConditionCascade({
    required ConditionDef conditionDef,
    required _ConditionGroupDef? parentGroup,
  }) {
    if (conditionDef is _ConditionDef) {
      // LAZY Initial.
      conditionDef.__group = parentGroup;
    } else if (conditionDef is _ConditionGroupDef) {
      // LAZY Initial.
      conditionDef.__group = parentGroup;
      for (ConditionDef childConditionDef in conditionDef.conditions) {
        __initConditionCascade(
          conditionDef: childConditionDef,
          parentGroup: conditionDef,
        );
      }
    } else {
      throw "Never Run";
    }
  }

  void __standardizeCascade(
    MultiOptFilterCriterionModel multiOptCriterion,
    MultiOptFilterCriterionModel? parent,
  ) {
    multiOptCriterion.parent = parent;
    multiOptCriterion._structure = this;
    //
    if (_allCriteriaMap.containsKey(multiOptCriterion.criterionNameX)) {
      throw DuplicateFilterCriterionError(
        criterionNameX: multiOptCriterion.criterionNameX,
      );
    }
    _allCriteriaMap[multiOptCriterion.criterionNameX] = multiOptCriterion;
    //
    for (MultiOptFilterCriterionModel child in multiOptCriterion.children) {
      __standardizeCascade(child, multiOptCriterion);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (formPropsStructure.allMultiOptProps)
  List<MultiOptFilterCriterionModel> get allMultiOptCriteria {
    return _allCriteriaMap.values
        .whereType<MultiOptFilterCriterionModel>()
        .cast<MultiOptFilterCriterionModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getCurrentCriterionValue({required String criterionNameX}) {
    FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
    if (criterion != null) {
      return criterion._currentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get _initialCriteriaValues {
    return _allCriteriaMap.map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get _currentCriteriaValues {
    return _allCriteriaMap.map((k, v) => MapEntry(k, v._currentValue));
  }

  Map<String, dynamic> get _tempCriteriaValues {
    return _allCriteriaMap.map((k, v) => MapEntry(k, v._tempCurrentValue));
  }

  @DebugMethodAnnotation()
  Map<String, dynamic> get debugInitialCriteriaValues => _initialCriteriaValues;

  @DebugMethodAnnotation()
  Map<String, dynamic> get debugCurrentCriteriaValues => _currentCriteriaValues;

  @DebugMethodAnnotation()
  Map<String, dynamic> get debugInstantValues {
    return filterModel._formKey.currentState?.instantValue ?? {};
  }

  @DebugMethodAnnotation()
  List<MultiOptFilterCriterionModel> get debugRootOptCriteria =>
      _rootOptCriteria;

  @DebugMethodAnnotation()
  List<SimpleFilterCriterionModel<dynamic>> get debugSimpleCriteria =>
      _simpleCriteria;

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterDataState(DataState filterDataState) {
    _filterDataState = filterDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempToReal() {
    for (FilterCriterionModel criterion in _allCriteriaMap.values) {
      criterion._currentValue = criterion._tempCurrentValue;
      criterion._currentXData = criterion._tempCurrentXData;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterionModel? _getMultiOptFilterCriterion(
      String multiOptCriterionNameX) {
    FilterCriterionModel? criterion = _allCriteriaMap[multiOptCriterionNameX];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleFilterCriterionModel? _getSimpleFilterCriterion(String criterionNameX) {
    FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
    if (criterion is SimpleFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isMultiOptFilterCriterion(String criterionNameX) {
    return _getMultiOptFilterCriterion(criterionNameX) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initTemporaryForNewActivity({
    required FilterActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterInput? filterInput,
  }) {
    __addCriteriaIfNeed(
      criterionNameXs: formKeyInstantValues.keys.toList(),
    );
    //
    for (FilterCriterionModel criterion in _allCriteriaMap.values) {
      switch (activityType) {
        case FilterActivityType.newFilt:
          if (filterInput != null && filterInput is! EmptyFilterInput) {
            criterion._tempCurrentValue = null;
            criterion._tempCurrentXData = null;
            criterion._tempInitialValue = null;
            criterion._tempInitialXData = null;
          } else {
            criterion._tempCurrentValue = criterion._currentValue;
            criterion._tempCurrentXData = criterion._currentXData;
            criterion._tempInitialValue = criterion._initialValue;
            criterion._tempInitialXData = criterion._initialXData;
            //
            if (formKeyInstantValues.containsKey(criterion.criterionNameX)) {
              if (criterion is SimpleFilterCriterionModel) {
                criterion._tempCurrentValue =
                    formKeyInstantValues[criterion.criterionNameX];
              }
            }
          }
        case FilterActivityType.updateFromFilterPanel:
          criterion._tempCurrentValue = criterion._currentValue;
          criterion._tempCurrentXData = criterion._currentXData;
          criterion._tempInitialValue = criterion._initialValue;
          criterion._tempInitialXData = criterion._initialXData;
          //
          if (formKeyInstantValues.containsKey(criterion.criterionNameX)) {
            if (criterion is SimpleFilterCriterionModel) {
              criterion._tempCurrentValue =
                  formKeyInstantValues[criterion.criterionNameX];
            }
          }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String criterionNameX}) {
    FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion._tempCurrentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptFilterCriterionModel multiOptCriterion,
  }) {
    for (MultiOptFilterCriterionModel child in multiOptCriterion.children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenMultiOptValueToNullCascade(multiOptCriterion: child);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempMultiOptCriterionXData(String criterionNameX) {
    FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion._tempCurrentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getMultiOptCriterionXData(String criterionNameX) {
    FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion._currentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateCriteriaTempValues(Map<String, dynamic> criterionValues) {
    __addCriteriaIfNeed(
      criterionNameXs: criterionValues.keys.toList(),
    );
    //
    final candidateUpdateValues = {...criterionValues};
    //
    // IMPORTANT:
    // Update data for FilterCriteriaStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (FilterCriterionModel criterion in _allCriteriaMap.values) {
      criterion._candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._markTempDirty = false;
    }
    //
    for (String criterionNameX in candidateUpdateValues.keys) {
      FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
      if (criterion != null) {
        criterion._markTempDirty = true;
      }
    }
    //
    for (MultiOptFilterCriterionModel rootCriterion in _rootOptCriteria) {
      rootCriterion._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleFilterCriterionModel simpleCriterion in _simpleCriteria) {
      simpleCriterion._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Criterion:
    for (FilterCriterionModel criterion in _allCriteriaMap.values) {
      if (criterion._markTempDirty) {
        criterion._tempCurrentValue = criterion._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addCriteriaIfNeed({required List<String> criterionNameXs}) {
    for (String criterionNameX in criterionNameXs) {
      FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
      if (criterion == null) {
        print("""\n
            ****************************************************************************************************
            *** WARNING ***: You should declare criterion '$criterionNameX' explicitly in ${getClassName(filterModel)}.
            ****************************************************************************************************
            """);
        //
        _createAndAddNewSimpleCriterion(
          criterionNameX: criterionNameX,
          markTempDirty: false,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewSimpleCriterion({
    required String criterionNameX,
    required bool markTempDirty,
  }) {
    if (_allCriteriaMap.containsKey(criterionNameX)) {
      return;
    }
    SimpleFilterCriterionModel? newSimpleCriterion = SimpleFilterCriterionModel(
      criterionNameX: criterionNameX,
    );
    __initSimpleCriterion(
      newSimpleCriterion: newSimpleCriterion,
      markTempDirty: markTempDirty,
    );
  }

  void __initSimpleCriterion({
    required SimpleFilterCriterionModel newSimpleCriterion,
    required bool markTempDirty,
  }) {
    newSimpleCriterion._structure = this;
    newSimpleCriterion._markTempDirty = markTempDirty;
    _allCriteriaMap[newSimpleCriterion.criterionNameX] = newSimpleCriterion;
    _simpleCriteria.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedCriterion({
    required CalculatedFilterCriterionModel newCalculatedCriterion,
    required bool markTempDirty,
  }) {
    newCalculatedCriterion._structure = this;
    newCalculatedCriterion._markTempDirty = markTempDirty;
    _allCriteriaMap[newCalculatedCriterion.criterionNameX] =
        newCalculatedCriterion;
    _calculatedCriteria.add(newCalculatedCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptCriterionXData({
    required String multiOptCriterionNameX,
    required XData? multiOptXData,
  }) {
    FilterCriterionModel? criterion = _allCriteriaMap[multiOptCriterionNameX];
    if (criterion == null) {
      throw AppError(errorMessage: 'No Criterion "$multiOptCriterionNameX"');
    }
    if (criterion is MultiOptFilterCriterionModel) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$multiOptCriterionNameX", it must be $MultiOptFilterCriterionModel');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionValue({
    required String criterionNameX,
    required Object? value,
  }) {
    FilterCriterionModel? criterion = _allCriteriaMap[criterionNameX];
    if (criterion == null) {
      throw AppError(
        errorMessage: 'No criterionNameX "$criterionNameX"',
        errorDetails: null,
      );
    } else if (criterion is! SimpleFilterCriterionModel) {
      throw AppError(
        errorMessage: '"$criterionNameX" is not $SimpleFilterCriterionModel',
        errorDetails: null,
      );
    }
    criterion._tempCurrentValue = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    for (FilterCriterionModel criterion in _allCriteriaMap.values) {
      bool dirty = criterion.isDirty();
      if (dirty) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo(String prefix) {
    print("\n\n--------------------------------------------------------------");
    print(" ---> $prefix");
    for (MultiOptFilterCriterionModel rootItem in _rootOptCriteria) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterionModel? _findMultiOptFilterCriterion(
      String multiOptFilterCriterion) {
    FilterCriterionModel? criterion = _allCriteriaMap[multiOptFilterCriterion];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  int _debugGetMultiOptCriterionLoadCount({
    required String multiOptCriterionNameX,
  }) {
    MultiOptFilterCriterionModel? criterion =
        _findMultiOptFilterCriterion(multiOptCriterionNameX);
    return criterion?._loadCount ?? 0;
  }
}
