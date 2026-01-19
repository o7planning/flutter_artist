part of '../../core.dart';

///
/// [FilterConditionGroupXVal], [FilterConditionXVal].
///
abstract interface class IConditionXVal {
  Map<String, dynamic> _toMapData();
}

class FilterConditionGroupXVal implements IConditionXVal {
  final String groupName;
  final ConditionConnector connector;
  final List<IConditionXVal> conditions;

  const FilterConditionGroupXVal({
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

class FilterConditionXVal implements IConditionXVal {
  final String criterionNameTilde;
  final CriterionOperator operator;
  final dynamic value;

  FilterConditionXVal({
    required this.criterionNameTilde,
    required this.operator,
    required this.value,
  });

  @override
  Map<String, dynamic> _toMapData() {
    return {
      "criterionNameTilde": criterionNameTilde,
      "value": value,
      "operator": operator.text,
    };
  }
}
