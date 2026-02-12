part of '../core.dart';

class FilterModelStructure {
  static const rootGroupName = "#ROOT-GROUP";

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
  final Map<String, CriterionDef> __allFieldDefMap = {};
  final Map<String, SimpleCriterionDef> __simpleCriterionDefMap = {};
  final Map<String, MultiOptCriterionDef> __multiOptCriterionDefMap = {};

  //
  // Condition Defs:
  //

  // String groupName.
  final Map<String, ConditionGroupDefImpl> __conditionGroupDefMap = {};

  //
  // Condition Models:
  //
  late final ConditionGroupDefImpl rootConditionGroupDef;

  //
  // Condition Models:
  //
  late final ConditionGroupModelImpl rootConditionGroupModel;

  // String tildeCriterionName.
  final Map<String, TildeFilterCriterionModel> _allCriterionModelMapX = {};
  final Map<String, MultiOptTildeFilterCriterionModel>
      _allOptCriterionModelMapX = {};

  final List<MultiOptTildeFilterCriterionModel> _rootOptCriterionModels = [];
  final List<SimpleTildeFilterCriterionModel> _simpleCriterionModels = [];
  final List<CalculatedTildeFilterCriterionModel> _calculatedCriterionModels =
      [];

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  // ***************************************************************************

  FilterModelStructure({
    required List<SimpleCriterionDef> simpleCriterionDefs,
    required List<MultiOptCriterionDef> multiOptCriterionDefs,
    required ConditionConnector conditionConnector,
    required List<ConditionDef> conditionDefs,
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
    rootConditionGroupDef = ConditionGroupDefImpl._(
      groupName: rootGroupName,
      connector: conditionConnector,
      conditions: conditionDefs,
    );
    // LAZY Property:
    rootConditionGroupModel = ConditionGroupModelImpl(
      groupName: rootGroupName,
      structure: this,
      connector: conditionConnector,
    );
    // All Defined tildeCriterionName(s).
    // String tildeCriterionName.
    final Set<String> allDefinedTildeCriterionNames = {};
    __calcAllDefinedTildeCriterionNames(
      conditionGroupDef: rootConditionGroupDef,
      allDefinedTildeCriterionNames: allDefinedTildeCriterionNames,
    );
    //
    for (ConditionDef conditionDef in conditionDefs) {
      __initConditionCascade(
        allDefinedTildeCriterionNames: allDefinedTildeCriterionNames,
        conditionDef: conditionDef,
        parentGroupDef: rootConditionGroupDef,
        parentGroupModel: rootConditionGroupModel,
      );
    }
    // Debug:
    // _printDebug();
    //
    // Create Criterion Models:
    //
    for (SimpleCriterionDef criterionDef in __simpleCriterionDefs) {
      for (String tildeSuffix in criterionDef._tildeSuffixes) {
        __createSimpleTildeCriterionModel(
          simpleCriterionDef: criterionDef,
          tildeSuffix: tildeSuffix,
        );
      }
    }
    for (MultiOptCriterionDef rootOptDef in __rootMultiOptCriterionDefs) {
      __createMultiOptTildeCriterionModelCascade(
        optCriterionDef: rootOptDef,
        parentOptTildeCriterionModel: null,
      );
    }
  }

  void _printDebug() {
    print("------------------------------------------------------------------");
    for (SimpleCriterionDef criterionDef in __simpleCriterionDefs) {
      criterionDef._printDebugTildeSuffixesCascade();
    }
    for (MultiOptCriterionDef rootOptDef in __rootMultiOptCriterionDefs) {
      rootOptDef._printDebugTildeSuffixesCascade();
    }
    print("------------------------------------------------------------------");
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createSimpleTildeCriterionModel({
    required SimpleCriterionDef simpleCriterionDef,
    required String tildeSuffix,
  }) {
    final String tildeCriterionName = NameTilde.createNameTilde(
      baseName: simpleCriterionDef.criterionBaseName,
      tildeSuffix: tildeSuffix,
    );
    final model = simpleCriterionDef.createTildeCriterionModel(
      tildeCriterionName: tildeCriterionName,
      criterionName: simpleCriterionDef.criterionBaseName,
      tildeSuffix: tildeSuffix,
    );
    _simpleCriterionModels.add(model);
    _allCriterionModelMapX[tildeCriterionName] = model;
  }

  // ***************************************************************************

  void __createMultiOptTildeCriterionModelCascade({
    required MultiOptCriterionDef optCriterionDef,
    required MultiOptTildeFilterCriterionModel? parentOptTildeCriterionModel,
  }) {
    for (String tildeSuffix in optCriterionDef._tildeSuffixes) {
      final String tildeCriterionName = NameTilde.createNameTilde(
        baseName: optCriterionDef.criterionBaseName,
        tildeSuffix: tildeSuffix,
      );
      //
      TildeCriterionConfig tildeCriterionConfig = optCriterionDef
          .findOrCreateTildeCriterionConfig(tildeSuffix: tildeSuffix);
      if (parentOptTildeCriterionModel != null &&
          parentOptTildeCriterionModel.parentMatchSuffix !=
              tildeCriterionConfig.parentMatchSuffix) {
        continue;
      }
      //
      final tildeCriterionModel = optCriterionDef.createTildeCriterionModel(
        tildeCriterionName: tildeCriterionName,
        criterionName: optCriterionDef.criterionBaseName,
        tildeSuffix: tildeSuffix,
        defaultSettingPolicy: tildeCriterionConfig.defaultSettingPolicy,
        parentMatchSuffix: tildeCriterionConfig.parentMatchSuffix,
        parent: parentOptTildeCriterionModel,
      );
      //
      if (parentOptTildeCriterionModel == null) {
        _rootOptCriterionModels.add(tildeCriterionModel);
      } else {
        parentOptTildeCriterionModel._children.add(tildeCriterionModel);
      }
      //
      _allCriterionModelMapX[tildeCriterionName] = tildeCriterionModel;
      //
      for (MultiOptCriterionDef childDef in optCriterionDef._children) {
        __createMultiOptTildeCriterionModelCascade(
          optCriterionDef: childDef,
          parentOptTildeCriterionModel: tildeCriterionModel,
        );
      }
    }
  }

  // ***************************************************************************

  void __initSimpleCriterionDef({
    required SimpleCriterionDef simpleCriterionDef,
  }) {
    if (__allCriterionDefMap
        .containsKey(simpleCriterionDef.criterionBaseName)) {
      throw DuplicateCriterionDefError(
        criterionBaseName: simpleCriterionDef.criterionBaseName,
      );
    }
    if (__allFieldDefMap.containsKey(simpleCriterionDef.fieldName)) {
      throw DuplicateCriterionFieldDefError(
        criterionBaseName: simpleCriterionDef.criterionBaseName,
        fieldName: simpleCriterionDef.fieldName,
      );
    }
    __allCriterionDefMap[simpleCriterionDef.criterionBaseName] =
        simpleCriterionDef;
    __allFieldDefMap[simpleCriterionDef.fieldName] = simpleCriterionDef;
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
        criterionBaseName: multiOptCriterionDef.criterionBaseName,
      );
    }
    if (__allFieldDefMap.containsKey(multiOptCriterionDef.fieldName)) {
      throw DuplicateCriterionFieldDefError(
        criterionBaseName: multiOptCriterionDef.criterionBaseName,
        fieldName: multiOptCriterionDef.fieldName,
      );
    }
    // Init LAZY Property.
    multiOptCriterionDef.parent = parent;
    __allCriterionDefMap[multiOptCriterionDef.criterionBaseName] =
        multiOptCriterionDef;
    __allFieldDefMap[multiOptCriterionDef.fieldName] = multiOptCriterionDef;
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

  void __calcAllDefinedTildeCriterionNames({
    required ConditionGroupDefImpl conditionGroupDef,
    required Set<String> allDefinedTildeCriterionNames,
  }) {
    for (ConditionDef conditionDef in conditionGroupDef.conditions) {
      if (conditionDef is ConditionDefImpl) {
        allDefinedTildeCriterionNames.add(conditionDef.tildeCriterionName);
      } else if (conditionDef is ConditionGroupDefImpl) {
        __calcAllDefinedTildeCriterionNames(
          conditionGroupDef: conditionDef,
          allDefinedTildeCriterionNames: allDefinedTildeCriterionNames,
        );
      } else {
        throw "Never Run";
      }
    }
  }

  void __debugTildeCriterionNames({
    required MultiOptCriterionDef multiOptCriterionDef,
  }) {
    multiOptCriterionDef.printDebugSuffixes();
    for (MultiOptCriterionDef child in multiOptCriterionDef._children) {
      __debugTildeCriterionNames(multiOptCriterionDef: child);
    }
  }

  // ***************************************************************************

  void __initConditionCascade({
    required Set<String> allDefinedTildeCriterionNames,
    required final ConditionDef conditionDef,
    required final ConditionGroupDefImpl parentGroupDef,
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
          criterionBaseName: conditionDef.criterionName,
          tildeCriterionName: conditionDef.tildeCriterionName,
        );
      }
      // LAZY Property:
      conditionDef.criterionDef = criterionDef;
      criterionDef._tildeSuffixes.add(conditionDef.tildeSuffix);
      //
      if (criterionDef is MultiOptCriterionDef) {
        TildeCriterionConfig tildeCriterionConfig =
            criterionDef.findOrCreateTildeCriterionConfig(
          tildeSuffix: conditionDef.tildeSuffix,
        );
        MultiOptCriterionDef? p = criterionDef;
        while (true) {
          p = p?.parent;
          if (p == null) {
            break;
          }
          String nameTildeParent = NameTilde.createNameTilde(
            baseName: p.criterionBaseName,
            tildeSuffix: tildeCriterionConfig.parentMatchSuffix,
          );
          if (allDefinedTildeCriterionNames.contains(nameTildeParent)) {
            break;
          }
          p._tildeSuffixes.add(tildeCriterionConfig.parentMatchSuffix);
        }
      }
      //
      ConditionModelImpl conditionModel = ConditionModelImpl(
        structure: this,
        criterionName: conditionDef.criterionName,
        tildeCriterionName: conditionDef.tildeCriterionName,
        criterionDef: conditionDef.criterionDef,
        operator: conditionDef.operator,
        supportedOperators: conditionDef._supportedOperators,
      );
      parentGroupModel._conditions.add(conditionModel);
    } else if (conditionDef is ConditionGroupDefImpl) {
      // LAZY Initial.
      conditionDef.__group = parentGroupDef;
      if (__conditionGroupDefMap.containsKey(conditionDef.groupName)) {
        throw DuplicateConditionGroupDefError(
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
          allDefinedTildeCriterionNames: allDefinedTildeCriterionNames,
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
  List<MultiOptTildeFilterCriterionModel> get allMultiOptCriteria {
    return _allCriterionModelMapX.values
        .whereType<MultiOptTildeFilterCriterionModel>()
        .cast<MultiOptTildeFilterCriterionModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getCurrentCriterionValue({required String tildeCriterionName}) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
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
  List<MultiOptTildeFilterCriterionModel> get debugRootOptCriteria =>
      _rootOptCriterionModels;

  @DebugMethodAnnotation()
  List<SimpleTildeFilterCriterionModel<dynamic>> get debugSimpleCriteria =>
      _simpleCriterionModels;

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterDataState(DataState filterDataState) {
    _filterDataState = filterDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempToReal() {
    for (TildeFilterCriterionModel criterion in _allCriterionModelMapX.values) {
      criterion._currentValue = criterion._tempCurrentValue;
      criterion._currentXData = criterion._tempCurrentXData;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptTildeFilterCriterionModel? _getMultiOptFilterCriterion(
      String multiOptTildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[multiOptTildeCriterionName];
    if (criterion is MultiOptTildeFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleTildeFilterCriterionModel? _getSimpleFilterCriterion(
      String tildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion is SimpleTildeFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isMultiOptFilterCriterion(String tildeCriterionName) {
    return _getMultiOptFilterCriterion(tildeCriterionName) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setupTemporaryStateForNewActivity({
    required FilterActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterInput? filterInput,
  }) {
    __addCriteriaIfNeed(
      tildeCriterionNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (TildeFilterCriterionModel criterion in _allCriterionModelMapX.values) {
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
                .containsKey(criterion.tildeCriterionName)) {
              if (criterion is SimpleTildeFilterCriterionModel) {
                criterion._tempCurrentValue =
                    formKeyInstantValues[criterion.tildeCriterionName];
              }
            }
          }
        case FilterActivityType.updateFromFilterPanel:
          criterion._tempCurrentValue = criterion._currentValue;
          criterion._tempCurrentXData = criterion._currentXData;
          criterion._tempInitialValue = criterion._initialValue;
          criterion._tempInitialXData = criterion._initialXData;
          //
          if (formKeyInstantValues.containsKey(criterion.tildeCriterionName)) {
            if (criterion is SimpleTildeFilterCriterionModel) {
              criterion._tempCurrentValue =
                  formKeyInstantValues[criterion.tildeCriterionName];
            }
          }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String tildeCriterionName}) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptTildeFilterCriterionModel) {
      return criterion._tempCurrentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptTildeFilterCriterionModel multiOptCriterion,
  }) {
    for (MultiOptTildeFilterCriterionModel child
        in multiOptCriterion.children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenMultiOptValueToNullCascade(multiOptCriterion: child);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempMultiOptCriterionXData(String tildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptTildeFilterCriterionModel) {
      return criterion._tempCurrentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getMultiOptTildeCriterionXData(String tildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptTildeFilterCriterionModel) {
      return criterion._currentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateCriteriaTempValues(Map<String, dynamic> criterionValues) {
    __addCriteriaIfNeed(
      tildeCriterionNames: criterionValues.keys.toList(),
    );
    //
    final candidateUpdateValues = {...criterionValues};
    //
    // IMPORTANT:
    // Update data for FilterCriteriaStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (TildeFilterCriterionModel criterion in _allCriterionModelMapX.values) {
      criterion._candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._markTempDirty = false;
    }
    //
    for (String tildeCriterionName in candidateUpdateValues.keys) {
      TildeFilterCriterionModel? criterion =
          _allCriterionModelMapX[tildeCriterionName];
      if (criterion != null) {
        criterion._markTempDirty = true;
      }
    }
    //
    for (MultiOptTildeFilterCriterionModel rootCriterion
        in _rootOptCriterionModels) {
      rootCriterion._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleTildeFilterCriterionModel simpleCriterion
        in _simpleCriterionModels) {
      simpleCriterion._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Criterion:
    for (TildeFilterCriterionModel criterion in _allCriterionModelMapX.values) {
      if (criterion._markTempDirty) {
        criterion._tempCurrentValue = criterion._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addCriteriaIfNeed({required List<String> tildeCriterionNames}) {
    for (String tildeCriterionName in tildeCriterionNames) {
      TildeFilterCriterionModel? criterion =
          _allCriterionModelMapX[tildeCriterionName];
      if (criterion == null) {
        // print("""\n
        //     ****************************************************************************************************
        //     *** WARNING ***: You should declare criterion '$tildeCriterionName' explicitly in ${getClassName(filterModel)}.
        //     ****************************************************************************************************
        //     """);
        //
        // _createAndAddNewSimpleCriterion(
        //   tildeCriterionName: tildeCriterionName,
        //   criterionName: criterionName,
        //   markTempDirty: false,
        // );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewSimpleCriterion({
    required String tildeCriterionName,
    required String criterionName,
    required String tildeSuffix,
    required bool markTempDirty,
  }) {
    if (_allCriterionModelMapX.containsKey(tildeCriterionName)) {
      return;
    }
    SimpleTildeFilterCriterionModel? newSimpleCriterion =
        SimpleTildeFilterCriterionModel(
      tildeCriterionName: tildeCriterionName,
      criterionName: criterionName,
      tildeSuffix: tildeSuffix,
    );
    __initSimpleCriterion(
      newSimpleCriterion: newSimpleCriterion,
      markTempDirty: markTempDirty,
    );
  }

  void __initSimpleCriterion({
    required SimpleTildeFilterCriterionModel newSimpleCriterion,
    required bool markTempDirty,
  }) {
    newSimpleCriterion._structure = this;
    newSimpleCriterion._markTempDirty = markTempDirty;
    _allCriterionModelMapX[newSimpleCriterion.tildeCriterionName] =
        newSimpleCriterion;
    _simpleCriterionModels.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedCriterion({
    required CalculatedTildeFilterCriterionModel newCalculatedCriterion,
    required bool markTempDirty,
  }) {
    newCalculatedCriterion._structure = this;
    newCalculatedCriterion._markTempDirty = markTempDirty;
    _allCriterionModelMapX[newCalculatedCriterion.tildeCriterionName] =
        newCalculatedCriterion;
    _calculatedCriterionModels.add(newCalculatedCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptCriterionXData({
    required String multiOptTildeCriterionName,
    required XData? multiOptXData,
  }) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[multiOptTildeCriterionName];
    if (criterion == null) {
      throw AppError(
          errorMessage: 'No Criterion "$multiOptTildeCriterionName"');
    }
    if (criterion is MultiOptTildeFilterCriterionModel) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$multiOptTildeCriterionName", it must be $MultiOptTildeFilterCriterionModel');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionValue({
    required String tildeCriterionName,
    required Object? value,
  }) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion == null) {
      throw AppError(
        errorMessage: 'No tildeCriterionName "$tildeCriterionName"',
        errorDetails: null,
      );
    } else if (criterion is! SimpleTildeFilterCriterionModel) {
      throw AppError(
        errorMessage:
            '"$tildeCriterionName" is not $SimpleTildeFilterCriterionModel',
        errorDetails: null,
      );
    }
    criterion._tempCurrentValue = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    for (TildeFilterCriterionModel criterion in _allCriterionModelMapX.values) {
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
    for (MultiOptTildeFilterCriterionModel rootItem
        in _rootOptCriterionModels) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptTildeFilterCriterionModel? _findMultiOptFilterCriterion({
    required String multiOptTildeCriterionName,
  }) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[multiOptTildeCriterionName];
    if (criterion is MultiOptTildeFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  int _debugGetMultiOptCriterionLoadCount({
    required String multiOptTildeCriterionName,
  }) {
    MultiOptTildeFilterCriterionModel? criterion = _findMultiOptFilterCriterion(
      multiOptTildeCriterionName: multiOptTildeCriterionName,
    );
    return criterion?._loadCount ?? 0;
  }
}
