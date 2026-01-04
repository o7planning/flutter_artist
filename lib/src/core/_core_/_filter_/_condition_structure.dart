part of '../core.dart';

class CriterionStructureDetail<V extends Object> {
  final String criterionName;
  final CriterionOperator operator;
  final List<CriterionOperator> supportedOperators;

  CriterionStructureDetail({
    required this.criterionName,
    required this.operator,
    required this.supportedOperators,
  });
}

class CriterionStructure<V extends Object> {
  final String criterionName;
  String? __jsonCriterionName;
  final List<CriterionOperator> supportedOperators;

  CriterionStructure({
    required this.criterionName,
    required this.supportedOperators,
  });
}

///
/// ```json
/// {
///   "supportedLogicalOperators": ["AND", "OR],
///   "conditions": [
///      {
///         "criterionName": "company"
///      },
///      {
///          "supportedLogicalOperators": ["OR"],
///          "conditions": [
///              {
///                "criterionName": "price"
///              },
///              {
///                "criterionName": "name"
///              }
///          ]
///      }
///    ]
/// }
/// ```
///
class ConditionStructure {
  final List<Conjunction>? supportedLogicalOperators;
  final List<ConditionStructure>? conditions;

  //
  final String? criterionName;

  @Deprecated("Delete")
  ConditionStructure.empty()
      : supportedLogicalOperators = [Conjunction.and],
        conditions = [],
        criterionName = null;

  ConditionStructure.conjunctionAnd({
    required List<ConditionStructure> this.conditions,
  })  : supportedLogicalOperators = [Conjunction.and],
        criterionName = null;

  ConditionStructure.conjunctionOr({
    required List<ConditionStructure> this.conditions,
  })  : supportedLogicalOperators = [Conjunction.or],
        criterionName = null;

  ConditionStructure.conjunctionAndOr({
    required List<ConditionStructure> this.conditions,
  })  : supportedLogicalOperators = [Conjunction.and, Conjunction.or],
        criterionName = null;

  ConditionStructure._logical({
    required List<Conjunction> this.supportedLogicalOperators,
    required List<ConditionStructure> this.conditions,
  }) : criterionName = null;

  ConditionStructure.criterion({
    required String this.criterionName,
    String? jsonCriterionName,
  })  : supportedLogicalOperators = null,
        conditions = null;

  // ConditionStructure toJsonConditionStructure() {
  //   if (__jsonCriterionName == null) {
  //     return ConditionStructure._logical(
  //       supportedLogicalOperators: supportedLogicalOperators!,
  //       conditions: conditions!,
  //     );
  //   } else {
  //     return ConditionStructure.criterion(
  //       criterionName: __jsonCriterionName!,
  //       jsonCriterionName: null,
  //     );
  //   }
  // }

  Map<String, dynamic> toMap({required List<FilterCriterion>? criteria}) {
    Map<String, FilterCriterion>? map =
        criteria == null ? null : {for (var v in criteria!) v.criterionName: v};
    //
    if (criterionName != null) {
      if (map == null) {
        return {
          "criterionName": criterionName,
        };
      } else {
        FilterCriterion? filterCriterion = map[criterionName];
        return {
          "criterionName": criterionName,
          "value": filterCriterion?.value,
        };
      }
    } else if (supportedLogicalOperators != null) {
      return {
        "supportedLogicalOperators":
            supportedLogicalOperators?.map((o) => o.text).toList(),
        "conditions":
            conditions!.map((c) => c.toMap(criteria: criteria)).toList(),
      };
    } else {
      throw "Never";
    }
  }
}
