part of '../core.dart';

class FilterModelStructure {
  static const rootGroupName = "#root-group";

  //
  // Criterion Defs:
  //
  final List<SimpleCriterionDef> __simpleCriterionDefs;
  final List<MultiOptCriterionDef> __rootMultiOptCriterionDefs;

  List<SimpleCriterionDef> get simpleCriterionDefs => __simpleCriterionDefs;

  List<MultiOptCriterionDef> get rootMultiOptCriterionDefs =>
      __rootMultiOptCriterionDefs;

  //
  final Map<String, CriterionDef> __allCriterionDefMap = {};
  final Map<String, SimpleCriterionDef> __simpleCriterionDefMap = {};
  final Map<String, MultiOptCriterionDef> __multiOptCriterionDefMap = {};

  //
  // Condition Defs:
  //
  final ConditionConnector conditionConnector;
  final List<ConditionDef> conditionDefs;

  // String groupName.
  final Map<String, ConditionGroupDefImpl> __conditionGroupDefMap = {};

  //
  // Condition Models:
  //
  late final ConditionGroupModelImpl rootConditionGroupModel;

  // String criterionNameTilde.
  final Map<String, FilterCriterionModel> _allCriterionModelMapX = {};
  final Map<String, MultiOptFilterCriterionModel> _allOptCriterionModelMapX =
      {};

  final List<MultiOptFilterCriterionModel> _rootOptCriterionModels = [];
  final List<SimpleFilterCriterionModel> _simpleCriterionModels = [];
  final List<CalculatedFilterCriterionModel> _calculatedCriterionModels = [];

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  // ***************************************************************************

  FilterModelStructure({
    required List<SimpleCriterionDef> simpleCriterionDefs,
    required List<MultiOptCriterionDef> multiOptCriterionDefs,
    required this.conditionConnector,
    required this.conditionDefs,
  })  : __simpleCriterionDefs = [...simpleCriterionDefs],
        __rootMultiOptCriterionDefs = [...multiOptCriterionDefs] {
    for (SimpleCriterionDef simpleCriterionDef in simpleCriterionDefs) {
      __initSimpleCriterionDef(simpleCriterionDef: simpleCriterionDef);
    }
    //
    for (MultiOptCriterionDef multiOptCriterionDef in multiOptCriterionDefs) {
      __initMultiOptCriterionDefCascade(
        multiOptCriterionDef: multiOptCriterionDef,
        parent: null,
      );
    }
    // LAZY Property:
    rootConditionGroupModel = ConditionGroupModelImpl(
      groupName: rootGroupName,
      structure: this,
      connector: conditionConnector,
    );
    for (ConditionDef conditionDef in conditionDefs) {
      __initConditionCascade(
        conditionDef: conditionDef,
        parentGroupDef: null,
        parentGroupModel: rootConditionGroupModel,
      );
    }
    //
    // Create Criterion Models:
    //
    for (SimpleCriterionDef criterionDef in __simpleCriterionDefs) {
      for (String suffix in criterionDef._suffixes) {
        __createSimpleFilterCriterionModel(
          simpleCriterionDef: criterionDef,
          suffix: suffix,
        );
      }
    }
    for (MultiOptCriterionDef rootOptDef in __rootMultiOptCriterionDefs) {
      for (String suffix in rootOptDef._suffixes) {
        __createMultiOptFilterCriterionModelCascade(
          optCriterionDef: rootOptDef,
          suffix: suffix,
          parentOptModel: null,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createSimpleFilterCriterionModel({
    required SimpleCriterionDef simpleCriterionDef,
    required String suffix,
  }) {
    final String criterionNameTilde = CriterionTilde.getNameTilde(
      baseName: simpleCriterionDef.criterionBaseName,
      suffix: suffix,
    );
    final model = simpleCriterionDef.createModel(
      criterionNameTilde: criterionNameTilde,
      criterionName: simpleCriterionDef.criterionBaseName,
    );
    _simpleCriterionModels.add(model);
    _allCriterionModelMapX[criterionNameTilde] = model;
  }

  // ***************************************************************************

  void __createMultiOptFilterCriterionModelCascade({
    required MultiOptCriterionDef optCriterionDef,
    required String suffix,
    required MultiOptFilterCriterionModel? parentOptModel,
  }) {
    if (!optCriterionDef._suffixes.contains(suffix)) {
      return;
    }
    final String criterionNameTilde = CriterionTilde.getNameTilde(
      baseName: optCriterionDef.criterionBaseName,
      suffix: suffix,
    );
    final model = optCriterionDef.createModel(
      criterionNameTilde: criterionNameTilde,
      criterionName: optCriterionDef.criterionBaseName,
      parent: parentOptModel,
    );
    if (parentOptModel == null) {
      _rootOptCriterionModels.add(model);
    }
    parentOptModel?._children.add(model);
    //
    _allCriterionModelMapX[criterionNameTilde] = model;
    for (MultiOptCriterionDef childDef in optCriterionDef._children) {
      __createMultiOptFilterCriterionModelCascade(
        optCriterionDef: childDef,
        suffix: suffix,
        parentOptModel: model,
      );
    }
  }

  // ***************************************************************************

  void __initSimpleCriterionDef({
    required SimpleCriterionDef simpleCriterionDef,
  }) {
    if (__allCriterionDefMap
        .containsKey(simpleCriterionDef.criterionBaseName)) {
      throw DuplicateCriterionDefError(
        criterionName: simpleCriterionDef.criterionBaseName,
      );
    }
    __allCriterionDefMap[simpleCriterionDef.criterionBaseName] =
        simpleCriterionDef;
    __simpleCriterionDefMap[simpleCriterionDef.criterionBaseName] =
        simpleCriterionDef;
  }

  // ***************************************************************************

  void __initMultiOptCriterionDefCascade({
    required MultiOptCriterionDef multiOptCriterionDef,
    required MultiOptCriterionDef? parent,
  }) {
    if (__allCriterionDefMap
        .containsKey(multiOptCriterionDef.criterionBaseName)) {
      throw DuplicateCriterionDefError(
        criterionName: multiOptCriterionDef.criterionBaseName,
      );
    }
    // Init LAZY Property.
    multiOptCriterionDef.parent = parent;
    __allCriterionDefMap[multiOptCriterionDef.criterionBaseName] =
        multiOptCriterionDef;
    __multiOptCriterionDefMap[multiOptCriterionDef.criterionBaseName] =
        multiOptCriterionDef;
    //
    for (MultiOptCriterionDef child in multiOptCriterionDef._children) {
      __initMultiOptCriterionDefCascade(
        multiOptCriterionDef: child,
        parent: multiOptCriterionDef,
      );
    }
  }

  // ***************************************************************************

  // final Map<String, MultiOptConditionModel> __multiOptConditionModelMapX = {};
  // final Map<String, SimpleConditionModel> __simpleConditionModelMapX = {};

  void __initConditionCascade({
    required final ConditionDef conditionDef,
    required final ConditionGroupDefImpl? parentGroupDef,
    required final ConditionGroupModelImpl parentGroupModel,
  }) {
    if (conditionDef is ConditionDefImpl) {
      // LAZY Initial.
      conditionDef.__group = parentGroupDef;
      //
      final CriterionDef? criterionDef =
          __allCriterionDefMap[conditionDef.criterionName];
      if (criterionDef == null) {
        throw FilterCriterionNotFoundError(
          criterionName: conditionDef.criterionName,
        );
      }
      criterionDef._suffixes.add(conditionDef.suffix);
      //
      if (criterionDef is MultiOptCriterionDef) {
        MultiOptCriterionDef? p = criterionDef;
        while (true) {
          p = p?.parent;
          if (p == null) {
            break;
          }
          p._suffixes.add(conditionDef.suffix);
        }
      }
      //
      ConditionModelImpl conditionModel = ConditionModelImpl(
        structure: this,
        criterionName: conditionDef.criterionName,
        criterionNameTilde: conditionDef.criterionNameTilde,
        operator: conditionDef.operator,
        supportedOperators: conditionDef._supportedOperators,
      );
      parentGroupModel._conditions.add(conditionModel);
    } else if (conditionDef is ConditionGroupDefImpl) {
      // LAZY Initial.
      conditionDef.__group = parentGroupDef;
      if (__conditionGroupDefMap.containsKey(conditionDef.groupName)) {
        throw DuplicateFilterCriteriaGroupError(
          groupName: conditionDef.groupName,
        );
      }
      __conditionGroupDefMap[conditionDef.groupName] = conditionDef;
      ConditionGroupModelImpl conditionGroupModel = ConditionGroupModelImpl(
        structure: this,
        groupName: conditionDef.groupName,
        connector: conditionDef.connector,
      );
      parentGroupModel._conditions.add(conditionGroupModel);
      //
      for (ConditionDef childConditionDef in conditionDef.conditions) {
        __initConditionCascade(
          conditionDef: childConditionDef,
          parentGroupDef: conditionDef,
          parentGroupModel: conditionGroupModel,
        );
      }
    } else {
      throw "Never Run";
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (formPropsStructure.allMultiOptProps)
  List<MultiOptFilterCriterionModel> get allMultiOptCriteria {
    return _allCriterionModelMapX.values
        .whereType<MultiOptFilterCriterionModel>()
        .cast<MultiOptFilterCriterionModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getCurrentCriterionValue({required String criterionNameTilde}) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[criterionNameTilde];
    if (criterion != null) {
      return criterion._currentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get _initialCriteriaValues {
    return _allCriterionModelMapX.map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get _currentCriteriaValues {
    return _allCriterionModelMapX.map((k, v) => MapEntry(k, v._currentValue));
  }

  Map<String, dynamic> get _tempCriteriaValues {
    return _allCriterionModelMapX
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
      _simpleCriterionModels;

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterDataState(DataState filterDataState) {
    _filterDataState = filterDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempToReal() {
    for (FilterCriterionModel criterion in _allCriterionModelMapX.values) {
      criterion._currentValue = criterion._tempCurrentValue;
      criterion._currentXData = criterion._tempCurrentXData;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterionModel? _getMultiOptFilterCriterion(
      String multiOptCriterionNameTilde) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[multiOptCriterionNameTilde];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleFilterCriterionModel? _getSimpleFilterCriterion(
      String criterionNameTilde) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[criterionNameTilde];
    if (criterion is SimpleFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isMultiOptFilterCriterion(String criterionNameTilde) {
    return _getMultiOptFilterCriterion(criterionNameTilde) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initTemporaryForNewActivity({
    required FilterActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterInput? filterInput,
  }) {
    __addCriteriaIfNeed(
      criterionNameTildes: formKeyInstantValues.keys.toList(),
    );
    //
    for (FilterCriterionModel criterion in _allCriterionModelMapX.values) {
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
            if (formKeyInstantValues
                .containsKey(criterion.criterionNameTilde)) {
              if (criterion is SimpleFilterCriterionModel) {
                criterion._tempCurrentValue =
                    formKeyInstantValues[criterion.criterionNameTilde];
              }
            }
          }
        case FilterActivityType.updateFromFilterPanel:
          criterion._tempCurrentValue = criterion._currentValue;
          criterion._tempCurrentXData = criterion._currentXData;
          criterion._tempInitialValue = criterion._initialValue;
          criterion._tempInitialXData = criterion._initialXData;
          //
          if (formKeyInstantValues.containsKey(criterion.criterionNameTilde)) {
            if (criterion is SimpleFilterCriterionModel) {
              criterion._tempCurrentValue =
                  formKeyInstantValues[criterion.criterionNameTilde];
            }
          }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String criterionNameTilde}) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[criterionNameTilde];
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

  XData? _getTempMultiOptCriterionXData(String criterionNameTilde) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[criterionNameTilde];
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

  XData? _getMultiOptCriterionXData(String criterionNameTilde) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[criterionNameTilde];
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
      criterionNameTildes: criterionValues.keys.toList(),
    );
    //
    final candidateUpdateValues = {...criterionValues};
    //
    // IMPORTANT:
    // Update data for FilterCriteriaStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (FilterCriterionModel criterion in _allCriterionModelMapX.values) {
      criterion._candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._markTempDirty = false;
    }
    //
    for (String criterionNameTilde in candidateUpdateValues.keys) {
      FilterCriterionModel? criterion =
          _allCriterionModelMapX[criterionNameTilde];
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
    for (SimpleFilterCriterionModel simpleCriterion in _simpleCriterionModels) {
      simpleCriterion._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Criterion:
    for (FilterCriterionModel criterion in _allCriterionModelMapX.values) {
      if (criterion._markTempDirty) {
        criterion._tempCurrentValue = criterion._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addCriteriaIfNeed({required List<String> criterionNameTildes}) {
    for (String criterionNameTilde in criterionNameTildes) {
      FilterCriterionModel? criterion =
          _allCriterionModelMapX[criterionNameTilde];
      if (criterion == null) {
        print("""\n
            ****************************************************************************************************
            *** WARNING ***: You should declare criterion '$criterionNameTilde' explicitly in ${getClassName(filterModel)}.
            ****************************************************************************************************
            """);
        //
        // _createAndAddNewSimpleCriterion(
        //   criterionNameTilde: criterionNameTilde,
        //   criterionName: criterionName,
        //   markTempDirty: false,
        // );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewSimpleCriterion({
    required String criterionNameTilde,
    required String criterionName,
    required bool markTempDirty,
  }) {
    if (_allCriterionModelMapX.containsKey(criterionNameTilde)) {
      return;
    }
    SimpleFilterCriterionModel? newSimpleCriterion = SimpleFilterCriterionModel(
      criterionNameTilde: criterionNameTilde,
      criterionName: criterionName,
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
    _allCriterionModelMapX[newSimpleCriterion.criterionNameTilde] =
        newSimpleCriterion;
    _simpleCriterionModels.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedCriterion({
    required CalculatedFilterCriterionModel newCalculatedCriterion,
    required bool markTempDirty,
  }) {
    newCalculatedCriterion._structure = this;
    newCalculatedCriterion._markTempDirty = markTempDirty;
    _allCriterionModelMapX[newCalculatedCriterion.criterionNameTilde] =
        newCalculatedCriterion;
    _calculatedCriterionModels.add(newCalculatedCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptCriterionXData({
    required String multiOptCriterionNameTilde,
    required XData? multiOptXData,
  }) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[multiOptCriterionNameTilde];
    if (criterion == null) {
      throw AppError(
          errorMessage: 'No Criterion "$multiOptCriterionNameTilde"');
    }
    if (criterion is MultiOptFilterCriterionModel) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$multiOptCriterionNameTilde", it must be $MultiOptFilterCriterionModel');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionValue({
    required String criterionNameTilde,
    required Object? value,
  }) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[criterionNameTilde];
    if (criterion == null) {
      throw AppError(
        errorMessage: 'No criterionNameTilde "$criterionNameTilde"',
        errorDetails: null,
      );
    } else if (criterion is! SimpleFilterCriterionModel) {
      throw AppError(
        errorMessage:
            '"$criterionNameTilde" is not $SimpleFilterCriterionModel',
        errorDetails: null,
      );
    }
    criterion._tempCurrentValue = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    for (FilterCriterionModel criterion in _allCriterionModelMapX.values) {
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

  MultiOptFilterCriterionModel? _findMultiOptFilterCriterion(
      String multiOptFilterCriterion) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[multiOptFilterCriterion];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  int _debugGetMultiOptCriterionLoadCount({
    required String multiOptCriterionNameTilde,
  }) {
    MultiOptFilterCriterionModel? criterion =
        _findMultiOptFilterCriterion(multiOptCriterionNameTilde);
    return criterion?._loadCount ?? 0;
  }
}
