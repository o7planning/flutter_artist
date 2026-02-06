part of '../../core.dart';

abstract class ConditionModel {
  FilterModelStructure get structure;

  ConditionModel._();

  IConditionVal toFilterRuleVal();

  IConditionXVal toFilterRuleXVal();
}

class ConditionModelImpl extends ConditionModel {
  @override
  final FilterModelStructure structure;
  final String criterionName;
  final String tildeCriterionName;
  final CriterionOperator operator;
  final CriterionDef criterionDef;

  final List<CriterionOperator> _supportedOperators;

  List<CriterionOperator> get supportedOperators =>
      List.unmodifiable(_supportedOperators);

  TildeFilterCriterionModel get filterCriterionModel {
    return structure._allCriterionModelMapX[tildeCriterionName]!;
  }

  ConditionModelImpl({
    required this.structure,
    required this.criterionName,
    required this.tildeCriterionName,
    required this.criterionDef,
    required this.operator,
    required List<CriterionOperator> supportedOperators,
  })  : _supportedOperators = supportedOperators,
        super._();

  @override
  IConditionVal toFilterRuleVal() {
    return FilterConditionVal(
      criterionName: criterionName,
      criterionDef: criterionDef,
      operator: operator,
      value: filterCriterionModel.currentValue,
    );
  }

  @override
  IConditionXVal toFilterRuleXVal() {
    return FilterConditionXVal(
      tildeCriterionName: tildeCriterionName,
      operator: operator,
      value: filterCriterionModel.currentValue,
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
    return toFilterRuleVal() as FilterConditionGroupVal;
  }

  FilterConditionGroupXVal toFilterCriteriaGroupXVal() {
    return toFilterRuleXVal() as FilterConditionGroupXVal;
  }

  @override
  IConditionVal toFilterRuleVal() {
    return FilterConditionGroupVal(
      groupName: groupName,
      connector: connector,
      conditions: _conditions.map((m) => m.toFilterRuleVal()).toList(),
    );
  }

  @override
  IConditionXVal toFilterRuleXVal() {
    return FilterConditionGroupXVal(
      groupName: groupName,
      connector: connector,
      conditions: _conditions.map((m) => m.toFilterRuleXVal()).toList(),
    );
  }
}
