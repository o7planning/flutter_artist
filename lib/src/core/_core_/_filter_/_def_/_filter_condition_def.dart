part of '../../core.dart';

abstract interface class ConditionDef {
  factory ConditionDef({
    required String criterionNameX,
    required CriterionOperator operator,
    List<CriterionOperator>? supportedOperators,
  }) {
    return _ConditionDef(
      criterionNameX: criterionNameX,
      operator: operator,
      supportedOperators: supportedOperators,
    );
  }

  factory ConditionDef.group({
    required String groupName,
    required FilterConnector connector,
    required List<ConditionDef> conditions,
  }) {
    return _ConditionGroupDef(
      groupName: groupName,
      connector: connector,
      conditions: conditions,
    );
  }
}

class _ConditionDef implements ConditionDef {
  final CriterionX _criterionX;
  final CriterionOperator operator;
  late final List<CriterionOperator> _supportedOperators;

  _ConditionDef({
    required String criterionNameX,
    required this.operator,
    List<CriterionOperator>? supportedOperators,
  }) : _criterionX = CriterionX.parse(
          criterionNameX: criterionNameX,
        ) {
    _supportedOperators = supportedOperators == null
        ? [operator]
        : {...supportedOperators, operator}.toList();
  }
}

class _ConditionGroupDef implements ConditionDef {
  final String groupName;
  final FilterConnector connector;
  final List<ConditionDef> conditions;

  _ConditionGroupDef({
    required this.groupName,
    required this.connector,
    required this.conditions,
  });
}
