part of '../../core.dart';

abstract class ConditionModel {
  FilterModelStructure get structure;

  ConditionModel._();

  IConditionVal toFilterConditionVal();

  IConditionTildeVal toFilterConditionTildeVal();
}

class ConditionModelImpl extends ConditionModel {
  @override
  final FilterModelStructure structure;
  final String criterionName;
  final String tildeCriterionName;
  final FilterOperator operator;
  final CriterionDef criterionDef;

  final List<FilterOperator> _supportedOperators;

  List<FilterOperator> get supportedOperators =>
      List.unmodifiable(_supportedOperators);

  TildeFilterCriterionModel get tildeFilterCriterionModel {
    return structure._allCriterionModelMapX[tildeCriterionName]!;
  }

  ConditionModelImpl({
    required this.structure,
    required this.criterionName,
    required this.tildeCriterionName,
    required this.criterionDef,
    required this.operator,
    required List<FilterOperator> supportedOperators,
  })  : _supportedOperators = supportedOperators,
        super._();

  @override
  IConditionVal toFilterConditionVal() {
    dynamic value = tildeFilterCriterionModel.currentValue;
    //
    return FilterConditionVal(
      criterionName: criterionName,
      criterionDef: criterionDef,
      operator: operator,
      value: value,
    );
  }

  @override
  IConditionTildeVal toFilterConditionTildeVal() {
    return FilterConditionTildeVal(
      tildeCriterionName: tildeCriterionName,
      operator: operator,
      value: tildeFilterCriterionModel.currentValue,
    );
  }
}

class ConditionGroupModelImpl extends ConditionModel {
  @override
  final FilterModelStructure structure;
  final String groupName;
  final ConditionConnector connector;

  List<ConditionConnector> get supportedConnectors => [connector];

  final List<ConditionModel> _conditions = [];

  List<ConditionModel> get conditions => _conditions;

  ConditionGroupModelImpl({
    required this.structure,
    required this.groupName,
    required this.connector,
  }) : super._();

  // ***************************************************************************
  // ***************************************************************************

  FilterConditionGroupVal toFilterCriteriaGroupVal() {
    return toFilterConditionVal() as FilterConditionGroupVal;
  }

  FilterConditionGroupTildeVal toFilterCriteriaGroupXVal() {
    return toFilterConditionTildeVal() as FilterConditionGroupTildeVal;
  }

  @override
  IConditionVal toFilterConditionVal() {
    return FilterConditionGroupVal(
      groupName: groupName,
      connector: connector,
      conditions: _conditions.map((m) => m.toFilterConditionVal()).toList(),
    );
  }

  @override
  IConditionTildeVal toFilterConditionTildeVal() {
    return FilterConditionGroupTildeVal(
      groupName: groupName,
      connector: connector,
      conditions:
          _conditions.map((m) => m.toFilterConditionTildeVal()).toList(),
    );
  }
}
