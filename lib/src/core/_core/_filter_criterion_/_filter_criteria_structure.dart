part of '../../_fa_core.dart';

class FilterCriteriaStructure {
  final Map<String, Criterion> _allCriteriaMap = {};
  final List<MultiOptCriterion> _rootOptCriteria;
  final List<SimpleCriterion> _simpleCriteria = [];
  final List<CalculatedCriterion> _calculatedCriteria = [];

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  FilterCriteriaStructure({
    required List<SimpleCriterion> simpleCriteria,
    required List<MultiOptCriterion> multiOptCriteria,
    List<CalculatedCriterion> calculatedCriteria = const [],
  }) : _rootOptCriteria = [...multiOptCriteria] {
    for (MultiOptCriterion rootOptCriterion in multiOptCriteria) {
      __standardizeCascade(rootOptCriterion, null);
    }
    for (SimpleCriterion sc in simpleCriteria) {
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
    for (CalculatedCriterion cc in calculatedCriteria) {
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
    MultiOptCriterion multiOptCriterion,
    MultiOptCriterion? parent,
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
    for (MultiOptCriterion child in multiOptCriterion.children) {
      __standardizeCascade(child, multiOptCriterion);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getCurrentCriterionValue({required String criterionName}) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion != null) {
      return criterion?._currentValue;
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

  Map<String, dynamic> get debugInitialCriteriaValues => _initialCriteriaValues;

  Map<String, dynamic> get debugCurrentCriteriaValues => _currentCriteriaValues;

  Map<String, dynamic> get debugInstantValues {
    return filterModel._formKey.currentState?.instantValue ?? {};
  }

  List<MultiOptCriterion> get debugRootOptCriteria => _rootOptCriteria;

  List<SimpleCriterion<dynamic>> get debugSimpleCriteria => _simpleCriteria;

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterDataState(DataState filterDataState) {
    _filterDataState = filterDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempToReal() {
    for (Criterion criterion in _allCriteriaMap.values) {
      criterion._currentValue = criterion._tempCurrentValue;
      criterion._currentXData = criterion._tempCurrentXData;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptCriterion? _getMultiOptCriterion(String multiOptCriterionName) {
    Criterion? criterion = _allCriteriaMap[multiOptCriterionName];
    if (criterion is MultiOptCriterion) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleCriterion? _getSimpleCriterion(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion is SimpleCriterion) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isOptCriterion(String criterionName) {
    return _getMultiOptCriterion(criterionName) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initTemporaryForNewTransaction({
    required FilterActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterInput? filterInput,
  }) {
    __addCriteriaIfNeed(
      criterionNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (Criterion criterion in _allCriteriaMap.values) {
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
              if (criterion is SimpleCriterion) {
                criterion._tempCurrentValue =
                    formKeyInstantValues[criterion.criterionName];
              }
            }
          }
        case FilterActivityType.updateFromFilterView:
          criterion._tempCurrentValue = criterion._currentValue;
          criterion._tempCurrentXData = criterion._currentXData;
          criterion._tempInitialValue = criterion._initialValue;
          criterion._tempInitialXData = criterion._initialXData;
          //
          if (formKeyInstantValues.containsKey(criterion.criterionName)) {
            if (criterion is SimpleCriterion) {
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
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptCriterion) {
      return criterion._tempCurrentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptCriterion multiOptCriterion,
  }) {
    for (MultiOptCriterion child in multiOptCriterion.children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenMultiOptValueToNullCascade(multiOptCriterion: child);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempOptCriterionXData(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptCriterion) {
      return criterion._tempCurrentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempMultiOptCriterionXData(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptCriterion) {
      return criterion._tempCurrentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getMultiOptCriterionXData(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptCriterion) {
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
    for (Criterion criterion in _allCriteriaMap.values) {
      criterion.candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._markTempDirty = false;
    }
    //
    for (String criterionName in candidateUpdateValues.keys) {
      Criterion? criterion = _allCriteriaMap[criterionName];
      if (criterion != null) {
        criterion._markTempDirty = true;
      }
    }
    //
    for (MultiOptCriterion rootCriterion in _rootOptCriteria) {
      rootCriterion._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleCriterion simpleCriterion in _simpleCriteria) {
      simpleCriterion._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Criterion:
    for (Criterion criterion in _allCriteriaMap.values) {
      if (criterion._markTempDirty) {
        criterion._tempCurrentValue = criterion.candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addCriteriaIfNeed({required List<String> criterionNames}) {
    for (String criterionName in criterionNames) {
      Criterion? criterion = _allCriteriaMap[criterionName];
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
    SimpleCriterion? newSimpleCriterion = SimpleCriterion(
      criterionName: criterionName,
    );
    __initSimpleCriterion(
      newSimpleCriterion: newSimpleCriterion,
      markTempDirty: markTempDirty,
    );
  }

  void __initSimpleCriterion({
    required SimpleCriterion newSimpleCriterion,
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
    required CalculatedCriterion newCalculatedCriterion,
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
    Criterion? criterion = _allCriteriaMap[multiOptCriterionName];
    if (criterion == null) {
      throw AppError(errorMessage: 'No Criterion "$multiOptCriterionName"');
    }
    if (criterion is MultiOptCriterion) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$multiOptCriterionName", it must be $MultiOptCriterion');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionValue({
    required String criterionName,
    required Object? value,
  }) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      throw AppError(
        errorMessage: 'No criterionName "$criterionName"',
        errorDetails: null,
      );
    } else if (criterion is! SimpleCriterion) {
      throw AppError(
        errorMessage: '"$criterionName" is not $SimpleCriterion',
        errorDetails: null,
      );
    }
    criterion._tempCurrentValue = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    for (Criterion criterion in _allCriteriaMap.values) {
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
    for (MultiOptCriterion rootItem in _rootOptCriteria) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------\n\n");
  }
}
