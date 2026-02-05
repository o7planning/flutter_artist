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
    // All Defined criterionNameTilde(s).
    final Set<String> allDefinedCriterionNameTildes = {};
    final Map<String, ConditionDef> allDefinedConditionDefMap = {};
    __calcAllDefinedCriterionNameTildes(
      conditionGroupDef: rootConditionGroupDef,
      allDefinedCriterionNameTildes: allDefinedCriterionNameTildes,
      allDefinedConditionDefMap: allDefinedConditionDefMap,
    );
    //
    for (ConditionDef conditionDef in conditionDefs) {
      __initConditionCascade(
        allDefinedCriterionNameTildes: allDefinedCriterionNameTildes,
        conditionDef: conditionDef,
        parentGroupDef: rootConditionGroupDef,
        parentGroupModel: rootConditionGroupModel,
      );
    }
    //
    // Create Criterion Models:
    //
    for (SimpleCriterionDef criterionDef in __simpleCriterionDefs) {
      for (String afterTildeSuffix in criterionDef._afterTildeSuffixes) {
        __createSimpleFilterCriterionModel(
          simpleCriterionDef: criterionDef,
          afterTildeSuffix: afterTildeSuffix,
        );
      }
    }
    for (MultiOptCriterionDef rootOptDef in __rootMultiOptCriterionDefs) {
      __createMultiOptFilterCriterionModelCascade(
        optCriterionDef: rootOptDef,
        parentOptModel: null,
        allDefinedConditionDefMap: allDefinedConditionDefMap,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createSimpleFilterCriterionModel({
    required SimpleCriterionDef simpleCriterionDef,
    required String afterTildeSuffix,
  }) {
    final String criterionNameTilde = NameTilde.getNameTilde(
      baseName: simpleCriterionDef.criterionBaseName,
      afterTildeSuffix: afterTildeSuffix,
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
    required MultiOptFilterCriterionModel? parentOptModel,
    required Map<String, ConditionDef> allDefinedConditionDefMap,
  }) {
    for (String afterTildeSuffix in optCriterionDef._afterTildeSuffixes) {
      final String criterionNameTilde = NameTilde.getNameTilde(
        baseName: optCriterionDef.criterionBaseName,
        afterTildeSuffix: afterTildeSuffix,
      );
      final ConditionDef? definedConditionDef =
          allDefinedConditionDefMap[criterionNameTilde];
      final DefaultSettingPolicy defaultSettingPolicy;
      final String? parentMatchSuffix;
      if (definedConditionDef is ConditionDefImpl) {
        defaultSettingPolicy = definedConditionDef.defaultSettingPolicy;
        parentMatchSuffix = definedConditionDef.parentMatchSuffix;
      } else {
        defaultSettingPolicy = DefaultSettingPolicy.onInitialOnly;
        parentMatchSuffix = null;
      }
      //
      final model = optCriterionDef.createModel(
        criterionNameTilde: criterionNameTilde,
        criterionName: optCriterionDef.criterionBaseName,
        parent: parentOptModel,
      );
      // LAZY Property:
      model.defaultSettingPolicy = defaultSettingPolicy;
      model.parentMatchSuffix = parentMatchSuffix;
      //
      if (parentOptModel == null) {
        _rootOptCriterionModels.add(model);
      }
      parentOptModel?._children.add(model);
      //
      _allCriterionModelMapX[criterionNameTilde] = model;
      for (MultiOptCriterionDef childDef in optCriterionDef._children) {
        __createMultiOptFilterCriterionModelCascade(
          optCriterionDef: childDef,
          parentOptModel: model,
          allDefinedConditionDefMap: allDefinedConditionDefMap,
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

  void __calcAllDefinedCriterionNameTildes({
    required ConditionGroupDefImpl conditionGroupDef,
    required Set<String> allDefinedCriterionNameTildes,
    required Map<String, ConditionDef> allDefinedConditionDefMap,
  }) {
    for (ConditionDef conditionDef in conditionGroupDef.conditions) {
      if (conditionDef is ConditionDefImpl) {
        allDefinedCriterionNameTildes.add(conditionDef.criterionNameTilde);
        allDefinedConditionDefMap[conditionDef.criterionNameTilde] =
            conditionDef;
      } else if (conditionDef is ConditionGroupDefImpl) {
        __calcAllDefinedCriterionNameTildes(
          conditionGroupDef: conditionDef,
          allDefinedCriterionNameTildes: allDefinedCriterionNameTildes,
          allDefinedConditionDefMap: allDefinedConditionDefMap,
        );
      } else {
        throw "Never Run";
      }
    }
  }

  void __debugCriterionNameTildes({
    required MultiOptCriterionDef multiOptCriterionDef,
  }) {
    multiOptCriterionDef.printDebugSuffixes();
    for (MultiOptCriterionDef child in multiOptCriterionDef._children) {
      __debugCriterionNameTildes(multiOptCriterionDef: child);
    }
  }

  // ***************************************************************************

  void __initConditionCascade({
    required Set<String> allDefinedCriterionNameTildes,
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
          criterionNameTilde: conditionDef.criterionNameTilde,
        );
      }
      // LAZY Property:
      conditionDef.criterionDef = criterionDef;
      criterionDef._afterTildeSuffixes.add(conditionDef.afterTildeSuffix);
      //
      if (criterionDef is MultiOptCriterionDef) {
        MultiOptCriterionDef? p = criterionDef;
        while (true) {
          p = p?.parent;
          if (p == null) {
            break;
          }
          String nameTildeParent = NameTilde.getNameTilde(
            baseName: p.criterionBaseName,
            afterTildeSuffix: conditionDef.parentMatchSuffix,
          );
          if (allDefinedCriterionNameTildes.contains(nameTildeParent)) {
            break;
          }
          p._afterTildeSuffixes.add(conditionDef.parentMatchSuffix);
        }
      }
      //
      ConditionModelImpl conditionModel = ConditionModelImpl(
        structure: this,
        criterionName: conditionDef.criterionName,
        criterionNameTilde: conditionDef.criterionNameTilde,
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
          allDefinedCriterionNameTildes: allDefinedCriterionNameTildes,
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
        // print("""\n
        //     ****************************************************************************************************
        //     *** WARNING ***: You should declare criterion '$criterionNameTilde' explicitly in ${getClassName(filterModel)}.
        //     ****************************************************************************************************
        //     """);
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

  MultiOptFilterCriterionModel? _findMultiOptFilterCriterion({
    required String multiOptCriterionNameTilde,
  }) {
    FilterCriterionModel? criterion =
        _allCriterionModelMapX[multiOptCriterionNameTilde];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  int _debugGetMultiOptCriterionLoadCount({
    required String multiOptCriterionNameTilde,
  }) {
    MultiOptFilterCriterionModel? criterion = _findMultiOptFilterCriterion(
      multiOptCriterionNameTilde: multiOptCriterionNameTilde,
    );
    return criterion?._loadCount ?? 0;
  }
}
