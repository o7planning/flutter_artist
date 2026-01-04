part of '../core.dart';

class FilterModelStructure {
  final List<MultiOptFilterCriterionDef> __rootOptCriterionDefs;

  List<MultiOptFilterCriterionDef> get rootOptCriterionDefs =>
      __rootOptCriterionDefs;

  //
  final Map<String, FilterCriterionDef> __allCriterionDefsMap = {};

  //
  final List<SimpleFilterCriterionDef> __simpleCriterionDefs = [];

  List<SimpleFilterCriterionDef> get simpleCriterionDefs =>
      List.unmodifiable(__simpleCriterionDefs);

  final List<CalculatedFilterCriterionDef> __calculatedCriterionDefs = [];

  List<CalculatedFilterCriterionDef> get calculatedCriterionDefs =>
      List.unmodifiable(__calculatedCriterionDefs);

  // String criterionNamePlus.
  final Map<String, FilterConditionModel> __allFilterConditionModelsPlusMap =
      {};

  // String criterionNamePlus.
  final Map<String, FilterCriterionModel> __allCriterionConditionModelsPlusMap =
      {};

  final List<SimpleFilterCriterionModel> __simpleCriterionModels = [];

  List<SimpleFilterCriterionModel> get simpleCriterionModels =>
      List.unmodifiable(__simpleCriterionModels);

  final List<CalculatedFilterCriterionModel> __calculatedCriterionModels = [];
  final List<MultiOptFilterCriterionModel> __optCriterionModels = [];
  final List<MultiOptFilterCriterionModel> _rootOptCriterionModels = [];

  List<MultiOptFilterCriterionModel> get rootOptCriterionModels =>
      List.unmodifiable(_rootOptCriterionModels);

  // String: criterionNamePlus
  final Map<String, FilterCriterionModel> _filterCriterionModelPlusMap = {};

  late final FilterModel filterModel;
  DataState _filterDataState = DataState.pending;

  late final FilterCriteriaGroupModel rootFilterCriteriaGroupModel;

  // ***************************************************************************

  FilterModelStructure({
    required List<SimpleFilterCriterionDef> simpleCriterionDefs,
    required List<MultiOptFilterCriterionDef> multiOptCriterionDefs,
    List<CalculatedFilterCriterionDef> calculatedCriterionDefs = const [],
    required FilterCriteriaGroupDef filterCriteriaGroupDef,
  }) : __rootOptCriterionDefs = multiOptCriterionDefs {
    for (MultiOptFilterCriterionDef rootOptCriterionDef
        in multiOptCriterionDefs) {
      __initMultiOptFilterCriterionDefCascade(
        multiOptCriterionDef: rootOptCriterionDef,
        parent: null,
      );
    }
    //
    for (SimpleFilterCriterionDef simpleCriterionDef in simpleCriterionDefs) {
      __initSimpleCriterionDef(
        newSimpleCriterionDef: simpleCriterionDef,
        markTempDirty: false,
      );
    }
    //
    for (CalculatedFilterCriterionDef calculatedCriterionDef
        in calculatedCriterionDefs) {
      __initCalculatedCriterionDef(
        newCalculatedCriterionDef: calculatedCriterionDef,
        markTempDirty: false,
      );
    }
    // Init LAZY Property:
    rootFilterCriteriaGroupModel = FilterCriteriaGroupModel(
      structure: this,
      filterCriteriaGroupDef: filterCriteriaGroupDef,
      parent: null,
    );
    // __standardizeCriteriaGroupCascade(
    //   filterCriteriaGroupDef: filterCriteriaGroupDef,
    //   parent: null,
    // );
  }

  FilterCriterionDef? findFilterCriterionDef(String criterionName) {
    return __allCriterionDefsMap[criterionName];
  }

  // ***************************************************************************

  FilterCriterionModel _findOrInitFilterCriterionModel({
    required final FilterConditionDef filterConditionDef,
  }) {
    // "album+", "album+suffix".
    final String criterionNamePlus = filterConditionDef.criterionNamePlus;
    final String criterionName = filterConditionDef.criterionName;
    final String? criterionSuffix = filterConditionDef.suffix;
    //
    FilterCriterionModel? criterionModel =
        __allCriterionConditionModelsPlusMap[criterionNamePlus];
    if (criterionModel != null) {
      return criterionModel;
    }
    //
    FilterCriterionDef? criterionDef = findFilterCriterionDef(criterionName);
    if (criterionDef == null) {
      throw FilterCriterionNotFoundError(criterionName: criterionName);
    }
    //
    if (criterionDef is SimpleFilterCriterionDef) {
      var simpleFilterCriterionModel = criterionDef.createModel(
        criterionNamePlus: criterionNamePlus,
        operator: filterConditionDef.operator,
      );
      __simpleCriterionModels.add(simpleFilterCriterionModel);
      __allCriterionConditionModelsPlusMap[criterionNamePlus] =
          simpleFilterCriterionModel;
      _addToFilterCriterionModelPlusMap(
        filterCriterionModel: simpleFilterCriterionModel,
      );
      return simpleFilterCriterionModel;
    }
    //
    else if (criterionDef is CalculatedFilterCriterionDef) {
      var calculatedFilterCriterionModel = criterionDef.createModel(
        criterionNamePlus: criterionNamePlus,
        operator: filterConditionDef.operator,
      );
      __calculatedCriterionModels.add(calculatedFilterCriterionModel);
      __allCriterionConditionModelsPlusMap[criterionNamePlus] =
          calculatedFilterCriterionModel;
      _addToFilterCriterionModelPlusMap(
        filterCriterionModel: calculatedFilterCriterionModel,
      );
      return calculatedFilterCriterionModel;
    }
    //
    else if (criterionDef is MultiOptFilterCriterionDef) {
      var multiOptFilterCriterionModel =
          __allCriterionConditionModelsPlusMap[criterionNamePlus]
              as MultiOptFilterCriterionModel?;
      if (multiOptFilterCriterionModel != null) {
        return multiOptFilterCriterionModel;
      }
      multiOptFilterCriterionModel = criterionDef.createModel(
        criterionNamePlus: criterionNamePlus,
      );
      __optCriterionModels.add(multiOptFilterCriterionModel);
      __allCriterionConditionModelsPlusMap[criterionNamePlus] =
          multiOptFilterCriterionModel;
      _addToFilterCriterionModelPlusMap(
        filterCriterionModel: multiOptFilterCriterionModel,
      );
      //
      if (criterionDef.parent != null) {
        final criterionNamePlus_parent = criterionSuffix == null
            ? criterionDef.parent!.criterionBaseName
            : "${criterionDef.parent!.criterionBaseName}+$criterionSuffix";
        //
        var multiOptFilterCriterionModelPARENT =
            _findOrInitFilterCriterionModel(
          filterConditionDef: FilterConditionDef(
            criterionNamePlus: criterionNamePlus_parent,
            operator: CriterionOperator.equalTo,
          ),
        ) as MultiOptFilterCriterionModel;
        //
        multiOptFilterCriterionModelPARENT._children
            .add(multiOptFilterCriterionModel);
        // Init LAZY property.
        multiOptFilterCriterionModel.parent =
            multiOptFilterCriterionModelPARENT;
      } else {
        // Init LAZY property.
        multiOptFilterCriterionModel.parent = null;
        _rootOptCriterionModels.add(multiOptFilterCriterionModel);
      }
      return multiOptFilterCriterionModel;
    }
    //
    else {
      throw "Never Run";
    }
  }

  // ***************************************************************************

  // ***************************************************************************

  void _addToFilterCriterionModelPlusMap({
    required FilterCriterionModel filterCriterionModel,
  }) {
    FilterCriterionModel? old =
        _filterCriterionModelPlusMap[filterCriterionModel.criterionNamePlus];
    if (old != null) {
      throw DuplicateFilterCriterionPlusError(
          criterionNamePlus: filterCriterionModel.criterionNamePlus);
    }
    _filterCriterionModelPlusMap[filterCriterionModel.criterionNamePlus] =
        filterCriterionModel;
  }

  // // ***************************************************************************
  //
  // List<CriterionStructureDetail> toCriterionStructureDetails() {
  //   final List<CriterionStructureDetail> ret = [];
  //   for (FilterCriterionModel model in __allCriterionDefsMap.values) {
  //     ret.add(
  //       CriterionStructureDetail(
  //         criterionName: model.criterionName,
  //         operator: model.operator,
  //         supportedOperators: model._supportedOperators,
  //       ),
  //     );
  //   }
  //   return ret;
  // }
  //
  // // ***************************************************************************
  //
  // ConditionStructureDetail __initDefaultConditionStructureDetail({
  //   required LogicalOperator conjunction,
  //   required Map<String, FilterCriterionModel> allCriterionModelsMap,
  // }) {
  //   final List<ConditionStructureDetail> conditions = [];
  //   for (String cn in allCriterionModelsMap.keys) {
  //     ConditionStructureDetail condition =
  //         ConditionStructureDetail.criterion(criterionName: cn);
  //     __setFilterCriterionModel(condition);
  //     conditions.add(condition);
  //   }
  //   //
  //   switch (conjunction) {
  //     case LogicalOperator.and:
  //       return ConditionStructureDetail.conjunctionAnd(
  //         conditions: conditions,
  //       );
  //     case LogicalOperator.or:
  //       return ConditionStructureDetail.conjunctionOr(
  //         conditions: conditions,
  //       );
  //   }
  // }
  //
  // // Set FilterCriterionModel for ConditionStructureDetail.
  // void __setFilterCriterionModel(
  //     ConditionStructureDetail conditionStructureDetail) {
  //   if (conditionStructureDetail.criterionName == null) {
  //     return;
  //   }
  //   FilterCriterionModel? model =
  //       __allCriterionDefsMap[conditionStructureDetail.criterionName!];
  //   // conditionStructureDetail._setPrivateValue(
  //   //   filterCriterionModel: model,
  //   // );
  // }
  //
  void __initMultiOptFilterCriterionDefCascade({
    required MultiOptFilterCriterionDef multiOptCriterionDef,
    required MultiOptFilterCriterionDef? parent,
  }) {
    multiOptCriterionDef.parent = parent;
    //
    if (__allCriterionDefsMap
        .containsKey(multiOptCriterionDef.criterionBaseName)) {
      throw DuplicateFilterCriterionError(
        criterionName: multiOptCriterionDef.criterionBaseName,
      );
    }
    __allCriterionDefsMap[multiOptCriterionDef.criterionBaseName] =
        multiOptCriterionDef;
    //
    for (MultiOptFilterCriterionDef child in multiOptCriterionDef.children) {
      __initMultiOptFilterCriterionDefCascade(
        multiOptCriterionDef: child,
        parent: multiOptCriterionDef,
      );
    }
  }

  // @Deprecated("Xoa di")
  // void __standardizeCriteriaGroupCascade({
  //   required FilterCriteriaGroupDef filterCriteriaGroupDef,
  //   required FilterCriteriaGroupModel? parent,
  // }) {
  //   final filterCriteriaGroupModel = FilterCriteriaGroupModel(
  //     filterCriteriaGroupDef: filterCriteriaGroupDef,
  //     parent: null,
  //   );
  //   filterCriteriaGroupModel._initProperties(this);
  //   filterCriteriaGroupModel.parent = parent;
  //
  //   if (parent == null) {
  //     // Init LAZY Property:
  //     rootFilterCriteriaGroupModel = filterCriteriaGroupModel;
  //   }
  //   //
  //   if (__filterCriteriaGroupModelMap
  //       .containsKey(filterCriteriaGroupDef.groupName)) {
  //     throw DuplicateFilterCriteriaGroupError(
  //       groupName: filterCriteriaGroupDef.groupName,
  //     );
  //   }
  //   __filterCriteriaGroupModelMap[filterCriteriaGroupDef.groupName] =
  //       filterCriteriaGroupModel;
  //   //
  //   for (FilterGroupMemberDef childMember in filterCriteriaGroupDef.members) {
  //     if (childMember is FilterCriteriaGroupDef) {
  //       __standardizeCriteriaGroupCascade(
  //         filterCriteriaGroupDef: childMember,
  //         parent: filterCriteriaGroupModel,
  //       );
  //     }
  //     //
  //     else if (childMember is FilterConditionDef) {
  //       //
  //     }
  //     //
  //     else {
  //       throw "Never Run";
  //     }
  //   }
  // }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (formModelStructure.allMultiOptPropModels)
  List<MultiOptFilterCriterionModel> get allMultiOptCriterionModels {
    return __allCriterionConditionModelsPlusMap.values
        .whereType<MultiOptFilterCriterionModel>()
        .cast<MultiOptFilterCriterionModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getCurrentCriterionValue({required String criterionNamePlus}) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[criterionNamePlus];
    if (criterion != null) {
      return criterion._currentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get _initialCriteriaValues {
    return __allCriterionConditionModelsPlusMap
        .map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get _currentCriteriaValues {
    return __allCriterionConditionModelsPlusMap
        .map((k, v) => MapEntry(k, v._currentValue));
  }

  Map<String, dynamic> get _tempCriteriaValues {
    return __allCriterionConditionModelsPlusMap
        .map((k, v) => MapEntry(k, v._tempCurrentValue));
  }

  @DebugMethodAnnotation()
  Map<String, dynamic> get debugInitialCriteriaValues {
    return rootFilterCriteriaGroupModel.debugInitialMapData;
  }

  @DebugMethodAnnotation()
  Map<String, dynamic> get debugCurrentCriteriaValues {
    return rootFilterCriteriaGroupModel.debugCurrentMapData;
  }

  @DebugMethodAnnotation()
  Map<String, dynamic> get debugInstantValues {
    return filterModel._formKey.currentState?.instantValue ?? {};
  }

  @DebugMethodAnnotation()
  List<MultiOptFilterCriterionDef> get debugRootOptCriteria =>
      __rootOptCriterionDefs;

  @DebugMethodAnnotation()
  List<SimpleFilterCriterionDef<dynamic>> get debugSimpleCriteria =>
      __simpleCriterionDefs;

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterDataState(DataState filterDataState) {
    _filterDataState = filterDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempToReal() {
    for (FilterCriterionModel criterion
        in __allCriterionConditionModelsPlusMap.values) {
      criterion._currentValue = criterion._tempCurrentValue;
      criterion._currentXData = criterion._tempCurrentXData;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterionModel? _getMultiOptFilterCriterionModel(
    String multiOptCriterionNamePlus,
  ) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[multiOptCriterionNamePlus];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleFilterCriterionModel? _getSimpleFilterCriterionModel(
      String criterionNamePlus) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[criterionNamePlus];
    if (criterion is SimpleFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isMultiOptFilterCriterionModel({required String criterionNamePlus}) {
    return _getMultiOptFilterCriterionModel(criterionNamePlus) != null;
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
    for (FilterCriterionModel criterion
        in __allCriterionConditionModelsPlusMap.values) {
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
              if (criterion is SimpleFilterCriterionDef) {
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
            if (criterion is SimpleFilterCriterionDef) {
              criterion._tempCurrentValue =
                  formKeyInstantValues[criterion.criterionName];
            }
          }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String criterionNamePlus}) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[criterionNamePlus];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterionDef) {
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

  XData? _getTempMultiOptCriterionXData({
    required String multiOptCriterionNamePlus,
  }) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[multiOptCriterionNamePlus];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterionDef) {
      return criterion._tempCurrentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getMultiOptCriterionXData({required String criterionNamePlus}) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[criterionNamePlus];
    if (criterion == null) {
      return null;
    }
    if (criterion is MultiOptFilterCriterionDef) {
      return criterion._currentXData;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateCriteriaTempValues(Map<String, dynamic> criterionValues) {
    // __addCriteriaIfNeed(
    //   criterionNames: criterionValues.keys.toList(),
    // );
    //
    final candidateUpdateValues = {...criterionValues};
    //
    // IMPORTANT:
    // Update data for FilterModelStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (FilterCriterionModel criterion
        in __allCriterionConditionModelsPlusMap.values) {
      criterion._candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._markTempDirty = false;
    }
    //
    for (String criterionName in candidateUpdateValues.keys) {
      FilterCriterionModel? criterion =
          __allCriterionConditionModelsPlusMap[criterionName];
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
    for (FilterCriterionModel criterion
        in __allCriterionConditionModelsPlusMap.values) {
      if (criterion._markTempDirty) {
        criterion._tempCurrentValue = criterion._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addCriteriaIfNeed({required List<String> criterionNames}) {
    for (String criterionName in criterionNames) {
      FilterCriterionDef? criterion = __allCriterionDefsMap[criterionName];
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
    throw "TODO-3";
    // if (__allCriterionDefsMap.containsKey(criterionName)) {
    //   return;
    // }
    // SimpleFilterCriterionModel? newSimpleCriterion = SimpleFilterCriterionModel(
    //   criterionNamePlus: criterionNamePlus,
    //   operator: CriterionOperator.equalTo,
    // );
    // __initSimpleCriterion(
    //   newSimpleCriterion: newSimpleCriterion,
    //   markTempDirty: markTempDirty,
    // );
  }

  void __initSimpleCriterionDef({
    required SimpleFilterCriterionDef newSimpleCriterionDef,
    required bool markTempDirty,
  }) {
    if (__allCriterionDefsMap
        .containsKey(newSimpleCriterionDef.criterionBaseName)) {
      throw DuplicateFilterCriterionError(
        criterionName: newSimpleCriterionDef.criterionBaseName,
      );
    }
    __allCriterionDefsMap[newSimpleCriterionDef.criterionBaseName] =
        newSimpleCriterionDef;
    __simpleCriterionDefs.add(newSimpleCriterionDef);
  }

  //
  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedCriterionDef({
    required CalculatedFilterCriterionDef newCalculatedCriterionDef,
    required bool markTempDirty,
  }) {
    if (__allCriterionDefsMap
        .containsKey(newCalculatedCriterionDef.criterionBaseName)) {
      throw DuplicateFilterCriterionError(
        criterionName: newCalculatedCriterionDef.criterionBaseName,
      );
    }
    __allCriterionDefsMap[newCalculatedCriterionDef.criterionBaseName] =
        newCalculatedCriterionDef;
    __calculatedCriterionDefs.add(newCalculatedCriterionDef);
  }

// ***************************************************************************
// ***************************************************************************

  void _setTempMultiOptCriterionXData({
    required String multiOptCriterionNamePlus,
    required XData? multiOptXData,
  }) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[multiOptCriterionNamePlus];
    if (criterion == null) {
      throw AppError(errorMessage: 'No Criterion "$multiOptCriterionNamePlus"');
    }
    if (criterion is MultiOptFilterCriterionModel) {
      criterion._tempCurrentXData = multiOptXData;
    } else {
      throw AppError(
          errorMessage:
              'Invalid Criterion "$multiOptCriterionNamePlus", it must be $MultiOptFilterCriterionModel');
    }
  }

// ***************************************************************************
// ***************************************************************************

  void _setTempSimpleCriterionValue({
    required String criterionNamePlus,
    required Object? value,
  }) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[criterionNamePlus];
    if (criterion == null) {
      throw AppError(
        errorMessage: 'No criterionNamePlus "$criterionNamePlus"',
        errorDetails: null,
      );
    } else if (criterion is! SimpleFilterCriterionDef) {
      throw AppError(
        errorMessage: '"$criterionNamePlus" is not $SimpleFilterCriterionDef',
        errorDetails: null,
      );
    }
    criterion._tempCurrentValue = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    for (FilterCriterionModel criterion
        in __allCriterionConditionModelsPlusMap.values) {
      bool dirty = criterion.isDirty();
      if (dirty) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // ConditionStructure toConditionStructure() {
  //   return conditionStructureDetail.toConditionStructure();
  // }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFilterCriterionModel? _findMultiOptFilterCriterionModel(
      String multiOptFilterCriterionPlus) {
    FilterCriterionModel? criterion =
        __allCriterionConditionModelsPlusMap[multiOptFilterCriterionPlus];
    if (criterion is MultiOptFilterCriterionModel) {
      return criterion;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  FilterCriterionModel? _findFilterCriterionModel({
    required String filterCriterionNamePlus,
  }) {
    FilterCriterionModel? criterionCondition =
        __allCriterionConditionModelsPlusMap[filterCriterionNamePlus];
    return criterionCondition;
  }

  // ***************************************************************************
  // ***************************************************************************

  int _debugGetMultiOptCriterionLoadCount({
    required String multiOptCriterionNamePlus,
  }) {
    MultiOptFilterCriterionModel? criterion =
        _findMultiOptFilterCriterionModel(multiOptCriterionNamePlus);
    return criterion?._loadCount ?? 0;
  }
}
