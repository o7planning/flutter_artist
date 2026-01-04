part of '../core.dart';

@immutable
abstract class FilterCriteria {
  final ConditionStructureDetail conditionStructure;
  final List<FilterCriterion> criteria;

  //
  late final List<CriterionStructure> __supportedCriterionStructures;
  late final ConditionStructure __supportedConditionStructure;
  late final ConditionStructure __supportedJsonConditionStructure;
  late final JsonFilterCriteria __jsonFilterCriteria;

  FilterCriteria({
    required this.conditionStructure,
    required this.criteria,
  }) {
    __supportedCriterionStructures = registerSupportedCriterionStructures();
    __supportedConditionStructure = registerSupportedConditionStructure();
    //
    // __supportedJsonConditionStructure =
    //     __supportedConditionStructure.toJsonConditionStructure();

    // TODO: Xem lai.
    __supportedJsonConditionStructure = __supportedConditionStructure;
    __jsonFilterCriteria = __toJsonFilterCriteria();
  }

  ///
  /// IMPORTANT.
  ///
  List<CriterionStructure> registerSupportedCriterionStructures() {
    throw UnimplementedError();
  }

  ///
  /// IMPORTANT.
  ///
  ConditionStructure registerSupportedConditionStructure() {
    return ConditionStructure.conjunctionAnd(
      conditions: [
        ConditionStructure.criterion(
          criterionName: "query1",
        ),
        ConditionStructure.criterion(
          criterionName: "query2",
        )
      ],
    );
  }

  JsonFilterCriterionValue toJsonFilterCriterionValue({
    required String criterionName,
    required Object? value,
  }) {
    throw UnimplementedError();
  }

  JsonFilterCriteria __toJsonFilterCriteria() {
    final List<JsonFilterCriterion> jsonCriteria = [];
    for (FilterCriterion filterCriterion in criteria) {
      final jsonCriterionValue = toJsonFilterCriterionValue(
        criterionName: filterCriterion.criterionName,
        value: filterCriterion.value,
      );
      JsonFilterCriterion jsonCriterion = JsonFilterCriterion(
        jsonCriterionName:
            filterCriterion.jsonCriterionName ?? filterCriterion.criterionName,
        value: jsonCriterionValue,
      );
      jsonCriteria.add(jsonCriterion);
    }
    return JsonFilterCriteria(
      condition: __supportedJsonConditionStructure,
      criteria: jsonCriteria,
    );
  }

  dynamic getFilterCriterionValue(String criterionName) {
    for (FilterCriterion c in criteria) {
      if (c.criterionName == criterionName) {
        return c.value;
      }
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return conditionStructure.toMap(criteria: criteria);
  }

  List<String> getDebugCriterionInfos();

  @override
  bool operator ==(Object other) {
    if (other is! FilterCriteria) {
      return false;
    }
    return __jsonFilterCriteria == other.__jsonFilterCriteria;
  }

  @override
  int get hashCode => __jsonFilterCriteria.hashCode;
}

class XFilterCriteria<FILTER_CRITERIA extends FilterCriteria>
    extends Equatable {
  final FILTER_CRITERIA filterCriteria;
  final Map<String, dynamic> filterCriteriaMap;

  const XFilterCriteria({
    required this.filterCriteria,
    required this.filterCriteriaMap,
  });

  @override
  List<Object?> get props => [filterCriteria];
}
