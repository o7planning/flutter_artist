part of '../core.dart';

///
/// ```json
/// {
///   "conjunction": "AND",
///   "conditions": [
///      {
///         "criterionName": "company"
///      },
///      {
///          "conjunction": "OR",
///          "conditions": [
///              {
///                "criterionName": "price"
///              },
///              {
///                "criterionName": "name"
///              },
///          ]
///      }
///    ]
/// }
/// ```
///
class FilterCondition {
  final Conjunction? conjunction;
  final List<Conjunction>? __conjunctions;

  List<Conjunction>? get conjunctions =>
      __conjunctions == null ? null : List.unmodifiable(__conjunctions!);

  final List<FilterCondition>? conditions;
  final String? criterionName;

  // Transient.
  FilterCriterionModel? _filterCriterionModel;

  FilterCondition.and({
    List<Conjunction>? conjunctions,
    required List<FilterCondition> this.conditions,
  })  : conjunction = Conjunction.and,
        __conjunctions = conjunctions == null
            ? [Conjunction.and]
            : {Conjunction.and, ...conjunctions!}.toList(),
        criterionName = null;

  FilterCondition.or({
    List<Conjunction>? conjunctions,
    required List<FilterCondition> this.conditions,
  })  : conjunction = Conjunction.or,
        __conjunctions = conjunctions == null
            ? [Conjunction.or]
            : {Conjunction.or, ...conjunctions!}.toList(),
        criterionName = null;

  FilterCondition.criterion({
    required String this.criterionName,
  })  : conjunction = null,
        __conjunctions = null,
        conditions = null;

  void _initLazyStructureCascade(FilterModelStructure structure) {
    conditions?.forEach((c) => c._initLazyStructureCascade(structure));
  }

  void _setPrivateValue({
    required FilterCriterionModel? filterCriterionModel,
  }) {
    _filterCriterionModel = filterCriterionModel;
  }

  ConditionStructureDetail toConditionStructure() {
    if (criterionName != null) {
      return ConditionStructureDetail.criterion(
        criterionName: criterionName!,
        // supportedOperators: _filterCriterionModel!.supportedOperators ?? [],
      );
    }
    //
    else if (__conjunctions != null) {
      return ConditionStructureDetail._conjunction(
        conjunction: conjunction!,
        supportedLogicalOperators: __conjunctions!,
        conditions: conditions == null
            ? []
            : conditions!
                .map(
                  (c) => c.toConditionStructure(),
                )
                .toList(),
      );
    }
    //
    else {
      throw "Never";
    }
  }

  Map<String, dynamic> toMap() {
    if (criterionName != null) {
      return {
        "criterionName": criterionName,
        "value": _filterCriterionModel?.currentValue,
        "operator": "??? _filterCriterionModel?.operator.name",
      };
    } else if (conjunction != null) {
      return {
        "conjunction": conjunction!.text,
        "conditions": conditions!.map((c) => c.toMap()).toList(),
      };
    } else {
      throw "TODO";
    }
  }
}
