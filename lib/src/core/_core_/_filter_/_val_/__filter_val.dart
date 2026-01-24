part of '../../core.dart';

///
/// [FilterConditionGroupVal], [FilterConditionVal].
///
abstract interface class IConditionVal {
  Map<String, dynamic> _toMapData();

  Map<String, dynamic> _toMapDataForBackend({
    required Map<String, Criterionable> criterionableMap,
  });
}

class FilterConditionVal implements IConditionVal {
  final String criterionName;
  final CriterionOperator operator;
  final dynamic value;

  FilterConditionVal({
    required this.criterionName,
    required this.operator,
    required this.value,
  });

  @override
  Map<String, dynamic> _toMapData() {
    return {
      "criterionName": criterionName,
      "value": value,
      "operator": operator.text,
    };
  }

  @override
  Map<String, dynamic> _toMapDataForBackend({
    required Map<String, Criterionable> criterionableMap,
  }) {
    Criterionable? cri = criterionableMap[criterionName];
    dynamic simpleValue;
    if (value is List) {
      simpleValue = [];
      for (dynamic val in value) {
        var simValue = cri?._convert(val);
        simpleValue.add(simValue);
      }
    } else {
      simpleValue = cri?._convert(value);
    }
    return {
      "criterionName": cri?.jsonCriterionName ?? criterionName,
      "value": simpleValue,
      "operator": operator.text,
    };
  }
}

class FilterConditionGroupVal implements IConditionVal {
  final String groupName;
  final ConditionConnector connector;
  final List<IConditionVal> conditions;

  const FilterConditionGroupVal({
    required this.groupName,
    required this.connector,
    required this.conditions,
  });

  const FilterConditionGroupVal.empty()
      : groupName = "root-criteria-group",
        connector = ConditionConnector.and,
        conditions = const [];

  @override
  Map<String, dynamic> _toMapData() {
    return {
      "connector": connector.text,
      "conditions": conditions.map((m) => m._toMapData()).toList(),
    };
  }

  @override
  Map<String, dynamic> _toMapDataForBackend({
    required Map<String, Criterionable> criterionableMap,
  }) {
    return {
      "connector": connector.text,
      "conditions": conditions
          .map(
              (m) => m._toMapDataForBackend(criterionableMap: criterionableMap))
          .toList(),
    };
  }

  String toJson({
    Map<String, Criterionable>? criterionableMap,
  }) {
    final Map<String, dynamic> map = _toMapData();
    return MapUtils.toJson(map: map);
  }

  String toJsonForBackend({
    required Map<String, Criterionable> criterionableMap,
  }) {
    final Map<String, dynamic> map = _toMapDataForBackend(
      criterionableMap: criterionableMap,
    );
    return MapUtils.toJson(map: map);
  }

  FilterConditionVal? findFilterCondition({
    required String criterionName,
  }) {
    for (IConditionVal rule in conditions) {
      if (rule is FilterConditionVal) {
        if (rule.criterionName == criterionName) {
          return rule;
        }
      }
    }
    for (IConditionVal rule in conditions) {
      if (rule is FilterConditionGroupVal) {
        FilterConditionVal? ruleVal = rule.findFilterCondition(
          criterionName: criterionName,
        );
        if (ruleVal != null) {
          return ruleVal;
        }
      }
    }
    return null;
  }
}
