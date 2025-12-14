part of '../core.dart';

class FilterCriteriaStructure {
  final Map<String, FilterCriterion> _allCriteriaMap = {};
  final List<MultiOptFilterCriterion> _rootOptCriteria;
  final List<SimpleFilterCriterion> _simpleCriteria = [];
  final List<CalculatedFilterCriterion> _calculatedCriteria = [];

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  FilterCriteriaStructure({
    required List<SimpleFilterCriterion> simpleCriteria,
    required List<MultiOptFilterCriterion> multiOptCriteria,
    List<CalculatedFilterCriterion> calculatedCriteria = const [],
  }) : _rootOptCriteria = List.unmodifiable(multiOptCriteria) {
    for (MultiOptFilterCriterion rootOptCriterion in multiOptCriteria) {
      __standardizeCascade(rootOptCriterion, null);
    }
    for (SimpleFilterCriterion sc in simpleCriteria) {
      if (_allCriteriaMap.containsKey(sc.criterionName)) {
        throw DuplicateFilterCriterionError(
          criterionName: sc.criterionName,
        );
      }
      __initSimpleCriterion(
        newSimpleCriterion: sc,
        markTempDirty: false,
      );
    }
    for (CalculatedFilterCriterion cc in calculatedCriteria) {
      if (_allCriteriaMap.containsKey(cc.criterionName)) {
        throw DuplicateFilterCriterionError(
          criterionName: cc.criterionName,
        );
      }
      __initCalculatedCriterion(
        newCalculatedCriterion: cc,
        markTempDirty: false,
      );
    }
  }

  void __standardizeCascade(
    MultiOptFilterCriterion multiOptCriterion,
    MultiOptFilterCriterion? parent,
  ) {
    multiOptCriterion.parent = parent;
    multiOptCriterion._structure = this;
    //
    if (_allCriteriaMap.containsKey(multiOptCriterion.criterionName)) {
      throw DuplicateFilterCriterionError(
        criterionName: multiOptCriterion.criterionName,
      );
    }
    _allCriteriaMap[multiOptCriterion.criterionName] = multiOptCriterion;
    //
    for (MultiOptFilterCriterion child in multiOptCriterion.children) {
      __standardizeCascade(child, multiOptCriterion);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (formPropsStructure.allMultiOptProps)
  List<MultiOptFilterCriterion> get allMultiOptCriteria {
    return _allCriteriaMap.values
        .whereType<MultiOptFilterCriterion>()
        .cast<MultiOptFilterCriterion>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getCurrentCriterionValue({required String criterionName}) {
    FilterCriterion? criterion = _allCriteriaMap[criterionName];
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
  List<MultiOptFilterCriterion> get debugRootOptCriteria => _rootOptCriteria;

  @DebugMethodAnnotation()
  List<SimpleFilterCriterion<dynamic>> get debugSimpleCriteria =>
      _simpleCriteria;

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterDataState(DataState filterDataState) {
    _filterDataState = filterDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempToReal() {
    for (FilterCriterion criterion in _allCriteriaMap.values) {
      criterion._currentValue = criterion._tempCurrentValue;
      criterion._currentXData = criterion._tempCurrentXData;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterion? _getMultiOptFilterCriterion(
      String multiOptCriterionName) {
    FilterCriterion? criterion = _allCriteriaMap[multiOptCriterionName];
    if (criterion is MultiOptFilterCriterion) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleFilterCriterion? _getSimpleFilterCriterion(String criterionName) {
    FilterCriterion? criterion = _allCriteriaMap[criterionName];
    if (criterion is SimpleFilterCriterion) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isMultiOptFilterCriterion(String criterionName) {
    return _getMultiOptFilterCriterion(criterionName) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initTemporaryForNewActivity({
    required FilterActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterInput? filterInput,
  }) {
    __addCriteriaIfNeed(
      criterionNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (FilterCriterion criterion in _allCriteriaMap.values) {
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
            if (formKeyInstantValues.containsKey(criterion.criterionName)) {
              if (criterion is SimpleFilterCriterion) {
                criterion._tempCurrentValue =
                    formKeyInstantValues[criterion.criterionName];
              }
            }
          }
        case FilterActivityType.updateFromFilterPanel:
          criterion._tempCurrentValue = criterion._currentValue;
          criterion._tempCurrentXData = criterion._currentXData;
          criterion._tempInitialValue = criterion._initialValue;
          criterion._tempInitialXData = criterion._initialXData;
          //
          if (formKeyInstantValues.containsKey(criterion.criterionName)) {
            if (criterion is SimpleFilterCriterion) {
              criterion._tempCurrentValue =
                  formKeyInstantValues[criterion.criterionName];
            }
          }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String criterionName}) {
    FilterCriterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterion) {
      return criterion._tempCurrentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptFilterCriterion multiOptCriterion,
  }) {
    for (MultiOptFilterCriterion child in multiOptCriterion.children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenMultiOptValueToNullCascade(multiOptCriterion: child);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempMultiOptCriterionXData(String criterionName) {
    FilterCriterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterion) {
      return criterion._tempCurrentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getMultiOptCriterionXData(String criterionName) {
    FilterCriterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterion) {
      return criterion._currentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateCriteriaTempValues(Map<String, dynamic> criterionValues) {
    __addCriteriaIfNeed(
      criterionNames: criterionValues.keys.toList(),
    );
    //
    final candidateUpdateValues = {...criterionValues};
    //
    // IMPORTANT:
    // Update data for FilterCriteriaStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (FilterCriterion criterion in _allCriteriaMap.values) {
      criterion._candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._markTempDirty = false;
    }
    //
    for (String criterionName in candidateUpdateValues.keys) {
      FilterCriterion? criterion = _allCriteriaMap[criterionName];
      if (criterion != null) {
        criterion._markTempDirty = true;
      }
    }
    //
    for (MultiOptFilterCriterion rootCriterion in _rootOptCriteria) {
      rootCriterion._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleFilterCriterion simpleCriterion in _simpleCriteria) {
      simpleCriterion._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Criterion:
    for (FilterCriterion criterion in _allCriteriaMap.values) {
      if (criterion._markTempDirty) {
        criterion._tempCurrentValue = criterion._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addCriteriaIfNeed({required List<String> criterionNames}) {
    for (String criterionName in criterionNames) {
      FilterCriterion? criterion = _allCriteriaMap[criterionName];
      if (criterion == null) {
        print("""\n
            ****************************************************************************************************
            *** WARNING ***: You should declare criterion '$criterionName' explicitly in ${getClassName(filterModel)}.
            ****************************************************************************************************
            """);
        //
        _createAndAddNewSimpleCriterion(
          criterionName: criterionName,
          markTempDirty: false,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewSimpleCriterion({
    required String criterionName,
    required bool markTempDirty,
  }) {
    if (_allCriteriaMap.containsKey(criterionName)) {
      return;
    }
    SimpleFilterCriterion? newSimpleCriterion = SimpleFilterCriterion(
      criterionName: criterionName,
    );
    __initSimpleCriterion(
      newSimpleCriterion: newSimpleCriterion,
      markTempDirty: markTempDirty,
    );
  }

  void __initSimpleCriterion({
    required SimpleFilterCriterion newSimpleCriterion,
    required bool markTempDirty,
  }) {
    newSimpleCriterion._structure = this;
    newSimpleCriterion._markTempDirty = markTempDirty;
    _allCriteriaMap[newSimpleCriterion.criterionName] = newSimpleCriterion;
    _simpleCriteria.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedCriterion({
    required CalculatedFilterCriterion newCalculatedCriterion,
    required bool markTempDirty,
  }) {
    newCalculatedCriterion._structure = this;
    newCalculatedCriterion._markTempDirty = markTempDirty;
    _allCriteriaMap[newCalculatedCriterion.criterionName] =
        newCalculatedCriterion;
    _calculatedCriteria.add(newCalculatedCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptCriterionXData({
    required String multiOptCriterionName,
    required XData? multiOptXData,
  }) {
    FilterCriterion? criterion = _allCriteriaMap[multiOptCriterionName];
    if (criterion == null) {
      throw AppError(errorMessage: 'No Criterion "$multiOptCriterionName"');
    }
    if (criterion is MultiOptFilterCriterion) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$multiOptCriterionName", it must be $MultiOptFilterCriterion');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionValue({
    required String criterionName,
    required Object? value,
  }) {
    FilterCriterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      throw AppError(
        errorMessage: 'No criterionName "$criterionName"',
        errorDetails: null,
      );
    } else if (criterion is! SimpleFilterCriterion) {
      throw AppError(
        errorMessage: '"$criterionName" is not $SimpleFilterCriterion',
        errorDetails: null,
      );
    }
    criterion._tempCurrentValue = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    for (FilterCriterion criterion in _allCriteriaMap.values) {
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
    for (MultiOptFilterCriterion rootItem in _rootOptCriteria) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterion? _findMultiOptFilterCriterion(
      String multiOptFilterCriterion) {
    FilterCriterion? criterion = _allCriteriaMap[multiOptFilterCriterion];
    if (criterion is MultiOptFilterCriterion) {
      return criterion;
    }
    return null;
  }

  int _debugGetMultiOptCriterionLoadCount({
    required String multiOptCriterionName,
  }) {
    MultiOptFilterCriterion? criterion =
        _findMultiOptFilterCriterion(multiOptCriterionName);
    return criterion?._loadCount ?? 0;
  }
}
