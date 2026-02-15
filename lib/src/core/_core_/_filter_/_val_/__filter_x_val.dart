part of '../../core.dart';

///
/// [FilterConditionGroupTildeVal], [FilterConditionTildeVal].
///
abstract interface class IConditionTildeVal {
  Map<String, dynamic> _toMapData();
}

class FilterConditionGroupTildeVal implements IConditionTildeVal {
  final String groupName;
  final FilterConnector connector;
  final List<IConditionTildeVal> conditions;

  const FilterConditionGroupTildeVal({
    required this.groupName,
    required this.connector,
    required this.conditions,
  });

  @override
  Map<String, dynamic> _toMapData() {
    return {
      "connector": connector.text,
      "conditions": conditions.map((m) => m._toMapData()).toList(),
    };
  }

  String toJson() {
    final Map<String, dynamic> map = _toMapData();
    return MapUtils.toJson(map: map);
  }
}

class FilterConditionTildeVal implements IConditionTildeVal {
  final String tildeCriterionName;
  final FilterOperator operator;
  final dynamic value;

  FilterConditionTildeVal({
    required this.tildeCriterionName,
    required this.operator,
    required this.value,
  });

  @override
  Map<String, dynamic> _toMapData() {
    return {
      "tildeCriterionName": tildeCriterionName,
      "value": value,
      "operator": operator.text,
    };
  }
}
