part of '../core.dart';

class FilterModelStructure {
  final List<MultiOptFilterCriterionModel> _rootOptCriterionModels;

  //
  final Map<String, FilterCriterionModel> __allCriterionModelsMap = {};

  //
  final List<SimpleFilterCriterionModel> __simpleCriterionModels = [];
  final List<CalculatedFilterCriterionModel> __calculatedCriterionModels = [];

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  FilterModelStructure({
    required List<SimpleFilterCriterionModel> simpleCriterionModels,
    required List<MultiOptFilterCriterionModel> multiOptCriterionModels,
    List<CalculatedFilterCriterionModel> calculatedCriterionModels = const [],
  }) : _rootOptCriterionModels = List.unmodifiable(multiOptCriterionModels) {
    for (MultiOptFilterCriterionModel rootOptCriterion
        in multiOptCriterionModels) {
      __standardizeCascade(rootOptCriterion, null);
    }
    for (SimpleFilterCriterionModel sc in simpleCriterionModels) {
      if (__allCriterionModelsMap.containsKey(sc.criterionName)) {
        throw DuplicateFilterCriterionError(
          criterionName: sc.criterionName,
        );
      }
      __initSimpleCriterion(
        newSimpleCriterion: sc,
        markTempDirty: false,
      );
    }
    for (CalculatedFilterCriterionModel cc in calculatedCriterionModels) {
      if (__allCriterionModelsMap.containsKey(cc.criterionName)) {
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
    MultiOptFilterCriterionModel multiOptCriterion,
    MultiOptFilterCriterionModel? parent,
  ) {
    multiOptCriterion.parent = parent;
    multiOptCriterion._structure = this;
    //
    if (__allCriterionModelsMap.containsKey(multiOptCriterion.criterionName)) {
      throw DuplicateFilterCriterionError(
        criterionName: multiOptCriterion.criterionName,
      );
    }
    __allCriterionModelsMap[multiOptCriterion.criterionName] =
        multiOptCriterion;
    //
    for (MultiOptFilterCriterionModel child in multiOptCriterion.children) {
      __standardizeCascade(child, multiOptCriterion);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (formModelStructure.allMultiOptPropModels)
  List<MultiOptFilterCriterionModel> get allMultiOptCriterionModels {
    return __allCriterionModelsMap.values
        .whereType<MultiOptFilterCriterionModel>()
        .cast<MultiOptFilterCriterionModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getCurrentCriterionValue({required String criterionName}) {
    FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
    if (criterion != null) {
      return criterion._currentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get _initialCriteriaValues {
    return __allCriterionModelsMap.map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get _currentCriteriaValues {
    return __allCriterionModelsMap.map((k, v) => MapEntry(k, v._currentValue));
  }

  Map<String, dynamic> get _tempCriteriaValues {
    return __allCriterionModelsMap
        .map((k, v) => MapEntry(k, v._tempCurrentValue));
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
      _rootOptCriterionModels;

  @DebugMethodAnnotation()
  List<SimpleFilterCriterionModel<dynamic>> get debugSimpleCriteria =>
      __simpleCriterionModels;

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterDataState(DataState filterDataState) {
    _filterDataState = filterDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempToReal() {
    for (FilterCriterionModel criterion in __allCriterionModelsMap.values) {
      criterion._currentValue = criterion._tempCurrentValue;
      criterion._currentXData = criterion._tempCurrentXData;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterionModel? _getMultiOptFilterCriterionModel(
      String multiOptCriterionName) {
    FilterCriterionModel? criterion =
        __allCriterionModelsMap[multiOptCriterionName];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleFilterCriterionModel? _getSimpleFilterCriterionModel(
      String criterionName) {
    FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
    if (criterion is SimpleFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isMultiOptFilterCriterionModel(String criterionName) {
    return _getMultiOptFilterCriterionModel(criterionName) != null;
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
    for (FilterCriterionModel criterion in __allCriterionModelsMap.values) {
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
              if (criterion is SimpleFilterCriterionModel) {
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
            if (criterion is SimpleFilterCriterionModel) {
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
    FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
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

  XData? _getTempMultiOptCriterionXData(String criterionName) {
    FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
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

  XData? _getMultiOptCriterionXData(String criterionName) {
    FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
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
      criterionNames: criterionValues.keys.toList(),
    );
    //
    final candidateUpdateValues = {...criterionValues};
    //
    // IMPORTANT:
    // Update data for FilterModelStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (FilterCriterionModel criterion in __allCriterionModelsMap.values) {
      criterion._candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._markTempDirty = false;
    }
    //
    for (String criterionName in candidateUpdateValues.keys) {
      FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
      if (criterion != null) {
        criterion._markTempDirty = true;
      }
    }
    //
    for (MultiOptFilterCriterionModel rootCriterion
        in _rootOptCriterionModels) {
      rootCriterion._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleFilterCriterionModel simpleCriterion
        in __simpleCriterionModels) {
      simpleCriterion._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Criterion:
    for (FilterCriterionModel criterion in __allCriterionModelsMap.values) {
      if (criterion._markTempDirty) {
        criterion._tempCurrentValue = criterion._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addCriteriaIfNeed({required List<String> criterionNames}) {
    for (String criterionName in criterionNames) {
      FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
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
    if (__allCriterionModelsMap.containsKey(criterionName)) {
      return;
    }
    SimpleFilterCriterionModel? newSimpleCriterion = SimpleFilterCriterionModel(
      criterionName: criterionName,
      operator: FilterCriterionOperator.equalTo,
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
    __allCriterionModelsMap[newSimpleCriterion.criterionName] =
        newSimpleCriterion;
    __simpleCriterionModels.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedCriterion({
    required CalculatedFilterCriterionModel newCalculatedCriterion,
    required bool markTempDirty,
  }) {
    newCalculatedCriterion._structure = this;
    newCalculatedCriterion._markTempDirty = markTempDirty;
    __allCriterionModelsMap[newCalculatedCriterion.criterionName] =
        newCalculatedCriterion;
    __calculatedCriterionModels.add(newCalculatedCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptCriterionXData({
    required String multiOptCriterionName,
    required XData? multiOptXData,
  }) {
    FilterCriterionModel? criterion =
        __allCriterionModelsMap[multiOptCriterionName];
    if (criterion == null) {
      throw AppError(errorMessage: 'No Criterion "$multiOptCriterionName"');
    }
    if (criterion is MultiOptFilterCriterionModel) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$multiOptCriterionName", it must be $MultiOptFilterCriterionModel');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionValue({
    required String criterionName,
    required Object? value,
  }) {
    FilterCriterionModel? criterion = __allCriterionModelsMap[criterionName];
    if (criterion == null) {
      throw AppError(
        errorMessage: 'No criterionName "$criterionName"',
        errorDetails: null,
      );
    } else if (criterion is! SimpleFilterCriterionModel) {
      throw AppError(
        errorMessage: '"$criterionName" is not $SimpleFilterCriterionModel',
        errorDetails: null,
      );
    }
    criterion._tempCurrentValue = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    for (FilterCriterionModel criterion in __allCriterionModelsMap.values) {
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
    for (MultiOptFilterCriterionModel rootItem in _rootOptCriterionModels) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterionModel? _findMultiOptFilterCriterionModel(
      String multiOptFilterCriterionModel) {
    FilterCriterionModel? criterion =
        __allCriterionModelsMap[multiOptFilterCriterionModel];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  int _debugGetMultiOptCriterionLoadCount({
    required String multiOptCriterionName,
  }) {
    MultiOptFilterCriterionModel? criterion =
        _findMultiOptFilterCriterionModel(multiOptCriterionName);
    return criterion?._loadCount ?? 0;
  }
}
