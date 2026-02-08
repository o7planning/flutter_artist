part of '../../core.dart';

///
/// [FilterConditionGroupVal], [FilterConditionVal].
///
abstract interface class IConditionVal {
  Map<String, dynamic> _toCriterionBasedMapData();

  Map<String, dynamic> _toFieldBasedMapData({required bool throwIfError});
}

class FilterConditionVal implements IConditionVal {
  final String criterionName;
  final CriterionDef criterionDef;
  final FilterOperator operator;
  final dynamic value;

  FilterConditionVal({
    required this.criterionName,
    required this.criterionDef,
    required this.operator,
    required this.value,
  });

  @override
  Map<String, dynamic> _toCriterionBasedMapData() {
    return {
      "criterionName": criterionName,
      "value": value,
      "operator": operator.text,
    };
  }

  @override
  Map<String, dynamic> _toFieldBasedMapData({required bool throwIfError}) {
    dynamic fieldValue;
    try {
      if (value == null) {
        fieldValue = null;
      } else if (value is List) {
        fieldValue =
            (value as List).map((v) => criterionDef._convert(v)).toList();
      } else {
        fieldValue = criterionDef._convert(value);
      }
    } catch (e) {
      if (throwIfError) {
        rethrow;
      }
      fieldValue = "The toFieldValue() method called with error: $e";
    }
    return {
      "field": criterionDef.fieldName,
      "operator": operator.text,
      "value": fieldValue,
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
  Map<String, dynamic> _toCriterionBasedMapData() {
    return {
      "connector": connector.text,
      "conditions":
          conditions.map((m) => m._toCriterionBasedMapData()).toList(),
    };
  }

  @override
  Map<String, dynamic> _toFieldBasedMapData({required bool throwIfError}) {
    return {
      "connector": connector.text,
      "conditions": conditions
          .map(
            (m) => m._toFieldBasedMapData(
              throwIfError: throwIfError,
            ),
          )
          .toList(),
    };
  }

  String toCriterionBasedJson() {
    final Map<String, dynamic> map = _toCriterionBasedMapData();
    return MapUtils.toJson(map: map);
  }

  String toFieldBasedJson({required bool throwIfError}) {
    final Map<String, dynamic> map = _toFieldBasedMapData(
      throwIfError: throwIfError,
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
