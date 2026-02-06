part of '../../core.dart';

///
/// [ConditionDefImpl], [ConditionGroupDefImpl].
///
abstract interface class ConditionDef {
  FilterModelStructure get structure;

  ConditionDef? get group;

  List<ConditionDef> get conditions;

  factory ConditionDef.condition({
    required String tildeCriterionName,
    required CriterionOperator operator,
    List<CriterionOperator>? supportedOperators,
  }) {
    return ConditionDefImpl._(
      tildeCriterionName: tildeCriterionName,
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

  final NameTilde _tildeObj;
  final CriterionOperator operator;
  late final List<CriterionOperator> _supportedOperators;

  //
  String get criterionName => _tildeObj.criterionName;

  String get tildeCriterionName => _tildeObj.tildeCriterionName;

  String get afterTildeSuffix => _tildeObj.afterTildeSuffix;

  String get tildeSuffix => _tildeObj.tildeSuffix;

  late final ConditionGroupDefImpl? __group;
  late final CriterionDef criterionDef;

  @override
  ConditionDef? get group => __group;

  @override
  List<ConditionDef> get conditions => [];

  ConditionDefImpl._({
    required String tildeCriterionName,
    required this.operator,
    List<CriterionOperator>? supportedOperators,
  }) : _tildeObj = NameTilde.parse(tildeCriterionName: tildeCriterionName) {
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
  }) {
    final Map<String, ConditionDef> map = {};
    for (ConditionDef def in conditions) {
      if (def is ConditionDefImpl) {
        final nameTilde = def._tildeObj.tildeCriterionName;
        if (map.containsKey(nameTilde)) {
          throw DuplicateFilterConditionDefError(
            tildeCriterionName: nameTilde,
            groupName: groupName,
          );
        }
        map[nameTilde] = def;
      }
    }
  }
}
