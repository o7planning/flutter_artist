part of '../core.dart';

class FilterCriteriaGroupModel<FILTER_INPUT extends FilterInput> extends _Core
    implements FilterConditionModel {
  final List<FilterCriteriaGroupModel> __childCriteriaGroupModels = [];

  List<FilterCriteriaGroupModel> get childCriteriaGroupModels =>
      List.unmodifiable(__childCriteriaGroupModels);

  //
  final List<FilterCriterionConditionModel> __childCriterionConditionModels =
      [];

  List<FilterCriterionConditionModel> get childCriterionConditionModels =>
      List.unmodifiable(__childCriterionConditionModels);

  //

  final List<FilterConditionModel> __childConditionModels = [];

  List<FilterConditionModel> get childConditionModels =>
      List.unmodifiable(__childConditionModels);

  //
  @Deprecated("Remove")
  final Map<String, FilterCriterionModel> __allCriterionModelsPlusMap = {};

  //
  late final FilterCriteriaGroupModel? parent;
  final FilterCriteriaGroupDef filterCriteriaGroupDef;
  late final FilterModelStructure structure;

  String get groupName => filterCriteriaGroupDef.groupName;

  Conjunction get conjunction => filterCriteriaGroupDef.conjunction;

  FilterModel get filterModel => structure.filterModel;

  FilterCriteriaGroupModel({
    required this.structure,
    required this.filterCriteriaGroupDef,
    required this.parent,
  }) {
    for (FilterGroupMemberDef member in filterCriteriaGroupDef.members) {
      // Child Group Def:
      if (member is FilterCriteriaGroupDef) {
        final childGroupModel = FilterCriteriaGroupModel(
          structure: structure,
          filterCriteriaGroupDef: member,
          parent: this,
        );
        __childCriteriaGroupModels.add(childGroupModel);
        __childConditionModels.add(childGroupModel);
      }
      // Condition Def:
      else if (member is FilterConditionDef) {
        // Init LAZY Property.
        member.group = filterCriteriaGroupDef;
        //
        final conditionModel = FilterCriterionConditionModel(
          structure: structure,
          filterConditionDef: member,
          parent: parent,
        );
        __childCriterionConditionModels.add(conditionModel);
        __childConditionModels.add(conditionModel);
      }
      //
      else {
        throw "Never Run";
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // List<SimpleFilterCriterionModel> get simpleCriterionModels {
  //   final List<SimpleFilterCriterionModel> list= [];
  //   for (FilterGroupMemberDef memberDef in filterCriteriaGroupDef.members) {
  //     if(memberDef is FilterConditionDef) {
  //       FilterCriterionModel model = structure._findMultiOptFilterCriterionModel(multiOptFilterCriterionPlus)
  //     }
  //
  //     // FilterConditionDef
  //     // FilterCriteriaGroupDef
  //   }
  // }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get _initialCriteriaValues {
    Map<String, FilterCriterionModel> map = {
      for (var v in __childCriterionConditionModels)
        v.criterionNamePlus: v.criterionModel
    };
    return map.map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get _currentCriteriaValues {
    Map<String, FilterCriterionModel> map = {
      for (var v in __childCriterionConditionModels)
        v.criterionNamePlus: v.criterionModel
    };
    return map.map((k, v) => MapEntry(k, v._currentValue));
  }

  Map<String, dynamic> get _tempCriteriaValues {
    Map<String, FilterCriterionModel> map = {
      for (var v in __childCriterionConditionModels)
        v.criterionNamePlus: v.criterionModel
    };
    return map.map((k, v) => MapEntry(k, v._tempCurrentValue));
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  Map<String, dynamic> toConditionMap() {
    final Map<String, dynamic> map = {
      "conjunction": conjunction.text,
      "members": __childConditionModels.map((m) => m.toConditionMap()).toList(),
    };
    return map;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get debugInitialMapData {
    final Map<String, dynamic> map = {..._initialCriteriaValues};
    for (FilterCriteriaGroupModel childModel in __childCriteriaGroupModels) {
      var map2 = childModel.debugInitialMapData;
      map[childModel.groupName] = map2;
    }
    if (parent == null) {
      return {groupName: map};
    }
    return map;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic> get debugCurrentMapData {
    final Map<String, dynamic> map = {..._currentCriteriaValues};
    for (FilterCriteriaGroupModel childModel in __childCriteriaGroupModels) {
      var map2 = childModel.debugCurrentMapData;
      map[childModel.groupName] = map2;
    }
    if (parent == null) {
      return {groupName: map};
    }
    return map;
  }
}
