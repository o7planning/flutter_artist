part of '../flutter_artist.dart';

class FilterCriteriaStructure {
  final Map<String, Criterion> _allCriteriaMap = {};
  final List<MultiOptCriterion> _rootOptCriteria;
  final List<SimpleCriterion> _simpleCriteria = [];

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  FilterCriteriaStructure({
    required List<String> simpleCriteria,
    required List<MultiOptCriterion> multiOptCriteria,
  }) : _rootOptCriteria = [...multiOptCriteria] {
    final List<String> simpleCriterionList = [...simpleCriteria];
    //
    for (MultiOptCriterion rootOptCriterion in multiOptCriteria) {
      __standardizeCascade(rootOptCriterion, null);
    }
    for (Criterion criterion in _allCriteriaMap.values) {
      simpleCriterionList.remove(criterion.criterionName);
      if (criterion is MultiOptCriterion) {
        criterion._checkCycleError();
      }
    }
    for (String criterionName in simpleCriterionList) {
      _createAndAddNewSimpleCriterion(
        criterionName: criterionName,
        markTempDirty: false,
      );
    }
  }

  void __standardizeCascade(
    MultiOptCriterion multiOptCriterion,
    MultiOptCriterion? parent,
  ) {
    multiOptCriterion.parent = parent;
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

  // TODO: DELETE?
  Map<String, dynamic> get initial0FormData {
    return {};
  }

  Map<String, dynamic> get initialFormData {
    return _allCriteriaMap.map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get currentFormData {
    return _allCriteriaMap.map((k, v) => MapEntry(k, v._currentValue));
  }

  Map<String, dynamic> get tempCurrentFormData {
    return _allCriteriaMap.map((k, v) => MapEntry(k, v._tempCurrentValue));
  }

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
    required _FilterDataAction filterDataAction,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterInput? filterInput,
  }) {
    __addCriteriaIfNeed(
      criterionNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (Criterion criterion in _allCriteriaMap.values) {
      switch (filterDataAction) {
        case _FilterDataAction.newFilt:
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
        case _FilterDataAction.updateFromFilterView:
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
    newSimpleCriterion._markTempDirty = markTempDirty;
    _allCriteriaMap[criterionName] = newSimpleCriterion;
    _simpleCriteria.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptCriterionXData({
    required String multiOptCriterionName,
    required XData? multiOptXData,
  }) {
    Criterion? criterion = _allCriteriaMap[multiOptCriterionName];
    if (criterion == null) {
      throw AppException(message: 'No Criterion "$multiOptCriterionName"');
    }
    if (criterion is MultiOptCriterion) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppException(
          message:
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
      throw AppException(
        message: 'No criterionName "$criterionName"',
        details: null,
      );
    } else if (criterion is! SimpleCriterion) {
      throw AppException(
        message: '"$criterionName" is not $SimpleCriterion',
        details: null,
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
