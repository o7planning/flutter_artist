part of '../core.dart';

@Deprecated("Khong su dung nua.")
class ConditionStructureDetail {
  final Conjunction? conjunction;
  final List<Conjunction>? supportedLogicalOperators;
  final List<ConditionStructureDetail>? conditions;

  //
  final String? criterionName;

  @Deprecated("Delete")
  ConditionStructureDetail.empty()
      : conjunction = Conjunction.and,
        supportedLogicalOperators = [Conjunction.and],
        conditions = [],
        criterionName = null;

  ConditionStructureDetail.conjunctionAnd({
    required List<ConditionStructureDetail> this.conditions,
  })  : conjunction = Conjunction.and,
        supportedLogicalOperators = [Conjunction.and],
        criterionName = null;

  ConditionStructureDetail.conjunctionOr({
    required List<ConditionStructureDetail> this.conditions,
  })  : conjunction = Conjunction.or,
        supportedLogicalOperators = [Conjunction.or],
        criterionName = null;

  ConditionStructureDetail.conjunctionAndOr({
    this.conjunction = Conjunction.and,
    required List<ConditionStructureDetail> this.conditions,
  })  : supportedLogicalOperators = [Conjunction.and, Conjunction.or],
        criterionName = null;

  ConditionStructureDetail._conjunction({
    Conjunction this.conjunction = Conjunction.and,
    required List<Conjunction> supportedLogicalOperators,
    required List<ConditionStructureDetail> this.conditions,
  })  : supportedLogicalOperators =
            (supportedLogicalOperators..add(conjunction)).toSet().toList(),
        criterionName = null;

  ConditionStructureDetail.criterion({
    required String this.criterionName,
  })  : conjunction = null,
        supportedLogicalOperators = null,
        conditions = null;

  ConditionStructure toConditionStructure() {
    if (supportedLogicalOperators != null) {
      return ConditionStructure._logical(
        supportedLogicalOperators: supportedLogicalOperators!,
        conditions: conditions!.map((c) => c.toConditionStructure()).toList(),
      );
    }
    //
    else if (criterionName != null) {
      return ConditionStructure.criterion(criterionName: criterionName!);
    }
    //
    else {
      throw "Neve Run";
    }
  }

  // ConditionStructureDetail toJsonConditionStructure() {
  //   if (__jsonCriterionName == null) {
  //     return ConditionStructureDetail._logical(
  //       conjunction: conjunction!,
  //       supportedLogicalOperators: supportedLogicalOperators!,
  //       conditions: conditions!,
  //     );
  //   } else {
  //     return ConditionStructureDetail.criterion(
  //       criterionName: __jsonCriterionName!,
  //       jsonCriterionName: null,
  //       operator: operator!,
  //       supportedOperators: supportedOperators!,
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
        "conjunction": conjunction?.text,
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
