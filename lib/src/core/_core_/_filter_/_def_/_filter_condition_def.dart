part of '../../core.dart';

abstract interface class ConditionDef {
  FilterModelStructure get structure;

  ConditionDef? get group;

  List<ConditionDef> get conditions;

  factory ConditionDef.single({
    required String criterionNameX,
    required CriterionOperator operator,
    List<CriterionOperator>? supportedOperators,
  }) {
    return ConditionDefImpl._(
      criterionNameX: criterionNameX,
      operator: operator,
      supportedOperators: supportedOperators,
    );
  }

  factory ConditionDef.group({
    required String groupName,
    required ConditionConnector connector,
    required List<ConditionDef> conditions,
  }) {
    return ConditionGroupDefImpl._(
      groupName: groupName,
      connector: connector,
      conditions: conditions,
    );
  }
}

class ConditionDefImpl implements ConditionDef {
  late final FilterModelStructure _structure;

  @override
  FilterModelStructure get structure => _structure;

  final CriterionX _criterionX;
  final CriterionOperator operator;
  late final List<CriterionOperator> _supportedOperators;

  //
  String get criterionName => _criterionX.criterionName;

  String get criterionNameX => _criterionX.criterionNameX;

  String get suffix => _criterionX.suffix!;

  late final ConditionGroupDefImpl? __group;

  @override
  ConditionDef? get group => __group;

  @override
  List<ConditionDef> get conditions => [];

  ConditionDefImpl._({
    required String criterionNameX,
    required this.operator,
    List<CriterionOperator>? supportedOperators,
  }) : _criterionX = CriterionX.parse(criterionNameX: criterionNameX) {
    _supportedOperators = supportedOperators == null
        ? [operator]
        : {...supportedOperators, operator}.toList();
  }
}

class ConditionGroupDefImpl implements ConditionDef {
  late final FilterModelStructure _structure;

  @override
  FilterModelStructure get structure => _structure;
  final String groupName;
  final ConditionConnector connector;

  late final ConditionGroupDefImpl? __group;

  @override
  ConditionDef? get group => __group;

  @override
  final List<ConditionDef> conditions;

  ConditionGroupDefImpl._({
    required this.groupName,
    required this.connector,
    required this.conditions,
  });
}
