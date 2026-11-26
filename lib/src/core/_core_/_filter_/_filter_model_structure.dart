part of '../core.dart';

class FilterModelStructure {
  static const rootGroupName = "#ROOT-GROUP";

  final FilterCriteriaStructure criteriaStructure;
  final FilterConditionStructure conditionStructure;

  //
  final Map<String, FilterCriterionDef> __allCriterionDefMap = {};
  final Map<String, FilterCriterionDef> __allFieldDefMap = {};
  final Map<String, PlainFilterCriterionDef> __plainCriterionDefMap = {};
  final Map<String, ManagedOptFilterCriterionDef> __managedOptCriterionDefMap =
      {};

  //
  // Condition Defs:
  //

  // String groupName.
  final Map<String, FilterConditionGroupDef> __conditionGroupDefMap = {};

  //
  // Condition Models:
  //
  late final FilterConditionGroupDef rootConditionGroupDef;

  //
  // Condition Models:
  //
  late final ConditionGroupModelImpl rootConditionGroupModel;

  // String tildeCriterionName.
  final Map<String, TildeFilterCriterionModel> _allCriterionModelMapX = {};

  final List<ManagedOptTildeFilterCriterionModel>
      _rootManagedOptCriterionModels = [];
  final List<PlainTildeFilterCriterionModel> _plainCriterionModels = [];
  final List<CalculatedTildeFilterCriterionModel> _calculatedCriterionModels =
      [];

  late final FilterModel filterModel;
  FilterDataState _draftFilterDataState = FilterDataStatePending();

  // ***************************************************************************

  FilterModelStructure({
    required this.criteriaStructure,
    required this.conditionStructure,
  }) {
    for (PlainFilterCriterionDef plainCriterionDef
        in criteriaStructure.plainCriterionDefs) {
      __initPlainCriterionDef(plainCriterionDef: plainCriterionDef);
    }
    //
    for (ManagedOptFilterCriterionDef managedOptCriterionDef
        in criteriaStructure.managedOptCriterionDefs) {
      __initManagedOptFilterCriterionDefCascade(
        managedOptCriterionDef: managedOptCriterionDef,
        parent: null,
      );
    }
    // LAZY Property:
    rootConditionGroupDef = FilterConditionGroupDef._(
      groupName: rootGroupName,
      connector: conditionStructure.connector,
      conditionDefs: conditionStructure.conditionDefs,
    );
    // LAZY Property:
    rootConditionGroupModel = ConditionGroupModelImpl(
      groupName: rootGroupName,
      structure: this,
      connector: conditionStructure.connector,
    );
    // All Defined tildeCriterionName(s).
    // String tildeCriterionName.
    final Set<String> allDefinedTildeCriterionNames = {};
    __calcAllDefinedTildeCriterionNames(
      conditionGroupDef: rootConditionGroupDef,
      allDefinedTildeCriterionNames: allDefinedTildeCriterionNames,
    );
    //
    for (FilterConditionDef conditionDef in conditionStructure.conditionDefs) {
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
    for (PlainFilterCriterionDef criterionDef
        in criteriaStructure.plainCriterionDefs) {
      for (String tildeSuffix in criterionDef._tildeSuffixes) {
        __createPlainTildeCriterionModel(
          plainCriterionDef: criterionDef,
          tildeSuffix: tildeSuffix,
        );
      }
    }
    for (ManagedOptFilterCriterionDef rootOptDef
        in criteriaStructure.managedOptCriterionDefs) {
      __createManagedOptTildeCriterionModelCascade(
        optCriterionDef: rootOptDef,
        parentOptTildeCriterionModel: null,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createPlainTildeCriterionModel({
    required PlainFilterCriterionDef plainCriterionDef,
    required String tildeSuffix,
  }) {
    final String tildeCriterionName = TildeObj.createNameTilde(
      baseName: plainCriterionDef.criterionBaseName,
      tildeSuffix: tildeSuffix,
    );
    final model = plainCriterionDef.createTildeCriterionModel(
      tildeCriterionName: tildeCriterionName,
      criterionName: plainCriterionDef.criterionBaseName,
      tildeSuffix: tildeSuffix,
    );
    _plainCriterionModels.add(model);
    _allCriterionModelMapX[tildeCriterionName] = model;
  }

  // ***************************************************************************

  void __createManagedOptTildeCriterionModelCascade({
    required ManagedOptFilterCriterionDef optCriterionDef,
    required ManagedOptTildeFilterCriterionModel? parentOptTildeCriterionModel,
  }) {
    for (String tildeSuffix in optCriterionDef._tildeSuffixes) {
      final String tildeCriterionName = TildeObj.createNameTilde(
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
        _rootManagedOptCriterionModels.add(tildeCriterionModel);
      } else {
        parentOptTildeCriterionModel._children.add(tildeCriterionModel);
      }
      //
      _allCriterionModelMapX[tildeCriterionName] = tildeCriterionModel;
      //
      for (ManagedOptFilterCriterionDef childDef in optCriterionDef._children) {
        __createManagedOptTildeCriterionModelCascade(
          optCriterionDef: childDef,
          parentOptTildeCriterionModel: tildeCriterionModel,
        );
      }
    }
  }

  // ***************************************************************************

  void __initPlainCriterionDef({
    required PlainFilterCriterionDef plainCriterionDef,
  }) {
    if (__allCriterionDefMap.containsKey(plainCriterionDef.criterionBaseName)) {
      throw FilterCriterionDuplicateNameError(
        criterionBaseName: plainCriterionDef.criterionBaseName,
      );
    }
    if (__allFieldDefMap.containsKey(plainCriterionDef.fieldName)) {
      throw FilterCriterionDuplicateFieldNameError(
        criterionBaseName: plainCriterionDef.criterionBaseName,
        fieldName: plainCriterionDef.fieldName,
      );
    }
    __allCriterionDefMap[plainCriterionDef.criterionBaseName] =
        plainCriterionDef;
    __allFieldDefMap[plainCriterionDef.fieldName] = plainCriterionDef;
    __plainCriterionDefMap[plainCriterionDef.criterionBaseName] =
        plainCriterionDef;
  }

  // ***************************************************************************

  void __initManagedOptFilterCriterionDefCascade({
    required ManagedOptFilterCriterionDef managedOptCriterionDef,
    required ManagedOptFilterCriterionDef? parent,
  }) {
    if (__allCriterionDefMap
        .containsKey(managedOptCriterionDef.criterionBaseName)) {
      throw FilterCriterionDuplicateNameError(
        criterionBaseName: managedOptCriterionDef.criterionBaseName,
      );
    }
    if (__allFieldDefMap.containsKey(managedOptCriterionDef.fieldName)) {
      throw FilterCriterionDuplicateFieldNameError(
        criterionBaseName: managedOptCriterionDef.criterionBaseName,
        fieldName: managedOptCriterionDef.fieldName,
      );
    }
    // Init LAZY Property.
    managedOptCriterionDef.parent = parent;
    __allCriterionDefMap[managedOptCriterionDef.criterionBaseName] =
        managedOptCriterionDef;
    __allFieldDefMap[managedOptCriterionDef.fieldName] = managedOptCriterionDef;
    __managedOptCriterionDefMap[managedOptCriterionDef.criterionBaseName] =
        managedOptCriterionDef;
    //
    for (ManagedOptFilterCriterionDef child
        in managedOptCriterionDef._children) {
      __initManagedOptFilterCriterionDefCascade(
        managedOptCriterionDef: child,
        parent: managedOptCriterionDef,
      );
    }
  }

  // ***************************************************************************

  void __calcAllDefinedTildeCriterionNames({
    required FilterConditionGroupDef conditionGroupDef,
    required Set<String> allDefinedTildeCriterionNames,
  }) {
    for (FilterConditionDef conditionDef in conditionGroupDef.conditionDefs) {
      if (conditionDef is FilterSimpleConditionDef) {
        allDefinedTildeCriterionNames.add(conditionDef.tildeCriterionName);
      } else if (conditionDef is FilterConditionGroupDef) {
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
    required ManagedOptFilterCriterionDef managedOptCriterionDef,
  }) {
    managedOptCriterionDef.printDebugSuffixes();
    for (ManagedOptFilterCriterionDef child
        in managedOptCriterionDef._children) {
      __debugTildeCriterionNames(managedOptCriterionDef: child);
    }
  }

  // ***************************************************************************

  void __initConditionCascade({
    required Set<String> allDefinedTildeCriterionNames,
    required final FilterConditionDef conditionDef,
    required final FilterConditionGroupDef parentGroupDef,
    required final ConditionGroupModelImpl parentGroupModel,
  }) {
    if (conditionDef is FilterSimpleConditionDef) {
      // LAZY Initial.
      conditionDef.__group = parentGroupDef;
      //
      final FilterCriterionDef? criterionDef =
          __allCriterionDefMap[conditionDef.criterionName];
      if (criterionDef == null) {
        throw TildeFilterCriterionBaseCriterionNotFoundError(
          criterionBaseName: conditionDef.criterionName,
          tildeCriterionName: conditionDef.tildeCriterionName,
        );
      }
      // LAZY Property:
      conditionDef.criterionDef = criterionDef;
      criterionDef._tildeSuffixes.add(conditionDef.tildeSuffix);
      //
      if (criterionDef is ManagedOptFilterCriterionDef) {
        TildeCriterionConfig tildeCriterionConfig =
            criterionDef.findOrCreateTildeCriterionConfig(
          tildeSuffix: conditionDef.tildeSuffix,
        );
        ManagedOptFilterCriterionDef? p = criterionDef;
        while (true) {
          p = p?.parent;
          if (p == null) {
            break;
          }
          String nameTildeParent = TildeObj.createNameTilde(
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
    } else if (conditionDef is FilterConditionGroupDef) {
      // LAZY Initial.
      conditionDef.__group = parentGroupDef;
      if (__conditionGroupDefMap.containsKey(conditionDef.groupName)) {
        throw FilterConditionGroupDuplicateNameError(
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
      for (FilterConditionDef childConditionDef in conditionDef.conditionDefs) {
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

  // SAME-AS: #0007 (formModelStructure.allManagedOptProps)
  List<ManagedOptTildeFilterCriterionModel> get allManagedOptCriteria {
    return _allCriterionModelMapX.values
        .whereType<ManagedOptTildeFilterCriterionModel>()
        .cast<ManagedOptTildeFilterCriterionModel>()
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

  // @DebugMethodAnnotation()
  // Map<String, dynamic> get debugInstantValues {
  //   return filterModel._formKey.currentState?.instantValue ?? {};
  // }

  @DebugMethodAnnotation()
  List<ManagedOptTildeFilterCriterionModel> get debugRootManagedOptCriteria =>
      _rootManagedOptCriterionModels;

  @DebugMethodAnnotation()
  List<PlainTildeFilterCriterionModel<dynamic>> get debugPlainCriteria =>
      _plainCriterionModels;

  // ***************************************************************************
  // ***************************************************************************

  void _setDraftFilterDataState(FilterDataState filterDataState) {
    _draftFilterDataState = filterDataState;
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

  ManagedOptTildeFilterCriterionModel? _getManagedOptFilterCriterion(
      String managedOptTildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[managedOptTildeCriterionName];
    if (criterion is ManagedOptTildeFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  PlainTildeFilterCriterionModel? _getPlainFilterCriterion(
      String tildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion is PlainTildeFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isManagedOptFilterCriterion(String tildeCriterionName) {
    return _getManagedOptFilterCriterion(tildeCriterionName) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setupTemporaryStateForNewActivity({
    required FilterActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterPatch? filterPatch,
  }) {
    __addCriteriaIfNeed(
      tildeCriterionNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (TildeFilterCriterionModel criterion in _allCriterionModelMapX.values) {
      switch (activityType) {
        case FilterActivityType.newFilt:
          if (filterPatch != null && filterPatch is! EmptyFilterPatch) {
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
              if (criterion is PlainTildeFilterCriterionModel) {
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
            if (criterion is PlainTildeFilterCriterionModel) {
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
    if (criterion is ManagedOptTildeFilterCriterionModel) {
      return criterion._tempCurrentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenManagedOptValueToNullCascade({
    required ManagedOptTildeFilterCriterionModel managedOptCriterion,
  }) {
    for (ManagedOptTildeFilterCriterionModel child
        in managedOptCriterion.children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenManagedOptValueToNullCascade(managedOptCriterion: child);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempManagedOptCriterionXData(String tildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is ManagedOptTildeFilterCriterionModel) {
      return criterion._tempCurrentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getManagedOptTildeCriterionXData(String tildeCriterionName) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[tildeCriterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is ManagedOptTildeFilterCriterionModel) {
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
    // Update data for FilterModelStructure. From ROOTs to LEAVES.
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
    for (ManagedOptTildeFilterCriterionModel rootCriterion
        in _rootManagedOptCriterionModels) {
      rootCriterion._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (PlainTildeFilterCriterionModel plainCriterion
        in _plainCriterionModels) {
      plainCriterion._updateTempValue(
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
        // _createAndAddNewPlainCriterion(
        //   tildeCriterionName: tildeCriterionName,
        //   criterionName: criterionName,
        //   markTempDirty: false,
        // );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewPlainCriterion({
    required String tildeCriterionName,
    required String criterionName,
    required String tildeSuffix,
    required bool markTempDirty,
  }) {
    if (_allCriterionModelMapX.containsKey(tildeCriterionName)) {
      return;
    }
    PlainTildeFilterCriterionModel? newPlainCriterion =
        PlainTildeFilterCriterionModel(
      tildeCriterionName: tildeCriterionName,
      criterionName: criterionName,
      tildeSuffix: tildeSuffix,
    );
    __initPlainCriterion(
      newPlainCriterion: newPlainCriterion,
      markTempDirty: markTempDirty,
    );
  }

  void __initPlainCriterion({
    required PlainTildeFilterCriterionModel newPlainCriterion,
    required bool markTempDirty,
  }) {
    newPlainCriterion._structure = this;
    newPlainCriterion._markTempDirty = markTempDirty;
    _allCriterionModelMapX[newPlainCriterion.tildeCriterionName] =
        newPlainCriterion;
    _plainCriterionModels.add(newPlainCriterion);
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

  void _setTempManagedOptCriterionXData({
    required String managedOptTildeCriterionName,
    required XData? managedOptXData,
  }) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[managedOptTildeCriterionName];
    if (criterion == null) {
      throw AppError(
          errorMessage: 'No Criterion "$managedOptTildeCriterionName"');
    }
    if (criterion is ManagedOptTildeFilterCriterionModel) {
      criterion._tempCurrentXData = managedOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$managedOptTildeCriterionName", it must be $ManagedOptTildeFilterCriterionModel');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempPlainCriterionValue({
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
    } else if (criterion is! PlainTildeFilterCriterionModel) {
      throw AppError(
        errorMessage:
            '"$tildeCriterionName" is not $PlainTildeFilterCriterionModel',
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
    for (ManagedOptTildeFilterCriterionModel rootItem
        in _rootManagedOptCriterionModels) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  ManagedOptTildeFilterCriterionModel? _findManagedOptFilterCriterion({
    required String managedOptTildeCriterionName,
  }) {
    TildeFilterCriterionModel? criterion =
        _allCriterionModelMapX[managedOptTildeCriterionName];
    if (criterion is ManagedOptTildeFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  int _debugGetManagedOptCriterionLoadCount({
    required String managedOptTildeCriterionName,
  }) {
    ManagedOptTildeFilterCriterionModel? criterion =
        _findManagedOptFilterCriterion(
      managedOptTildeCriterionName: managedOptTildeCriterionName,
    );
    return criterion?._loadCount ?? 0;
  }
}
