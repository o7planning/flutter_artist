part of '../../core.dart';

///
/// [FilterSimpleConditionDef], [FilterConditionGroupDef].
///
abstract interface class FilterConditionDef {
  FilterModelStructure get structure;

  FilterConditionDef? get group;

  List<FilterConditionDef> get conditionDefs;

  factory FilterConditionDef.simple({
    required String tildeCriterionName,
    required FilterOperator operator,
    List<FilterOperator>? supportedOperators,
  }) {
    return FilterSimpleConditionDef._(
      tildeCriterionName: tildeCriterionName,
      operator: operator,
      supportedOperators: supportedOperators,
    );
  }

  factory FilterConditionDef.group({
    required String groupName,
    required FilterConnector connector,
    required List<FilterConditionDef> conditionDefs,
  }) {
    return FilterConditionGroupDef._(
      groupName: groupName,
      connector: connector,
      conditionDefs: conditionDefs,
    );
  }
}

class FilterSimpleConditionDef implements FilterConditionDef {
  late final FilterModelStructure _structure;

  @override
  FilterModelStructure get structure => _structure;

  final TildeObj _tildeObj;
  final FilterOperator operator;
  late final List<FilterOperator> _supportedOperators;

  //
  String get criterionName => _tildeObj.criterionName;

  String get tildeCriterionName => _tildeObj.tildeCriterionName;

  String get afterTildeSuffix => _tildeObj.afterTildeSuffix;

  String get tildeSuffix => _tildeObj.tildeSuffix;

  late final FilterConditionGroupDef? __group;
  late final FilterCriterionDef criterionDef;

  @override
  FilterConditionDef? get group => __group;

  @override
  List<FilterConditionDef> get conditionDefs => [];

  FilterSimpleConditionDef._({
    required String tildeCriterionName,
    required this.operator,
    List<FilterOperator>? supportedOperators,
  }) : _tildeObj = TildeObj.parse(tildeCriterionName: tildeCriterionName) {
    _supportedOperators = supportedOperators == null
        ? [operator]
        : {...supportedOperators, operator}.toList();
  }
}

class FilterConditionGroupDef implements FilterConditionDef {
  late final FilterModelStructure _structure;

  @override
  FilterModelStructure get structure => _structure;
  final String groupName;
  final FilterConnector connector;

  late final FilterConditionGroupDef? __group;

  @override
  FilterConditionDef? get group => __group;

  @override
  final List<FilterConditionDef> conditionDefs;

  FilterConditionGroupDef._({
    required this.groupName,
    required this.connector,
    required this.conditionDefs,
  }) {
    final Map<String, FilterConditionDef> map = {};
    for (FilterConditionDef def in conditionDefs) {
      if (def is FilterSimpleConditionDef) {
        final nameTilde = def._tildeObj.tildeCriterionName;
        if (map.containsKey(nameTilde)) {
          throw FilterConditionGroupDuplicateTildeError(
            tildeCriterionName: nameTilde,
            groupName: groupName,
          );
        }
        map[nameTilde] = def;
      }
    }
  }
}
