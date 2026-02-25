part of '../core.dart';

abstract class FilterCriteria {
  late final String __fieldBasedJSON;

  String get fieldBasedJSON => __fieldBasedJSON;

  late final FilterConditionGroupVal __baseCriteria;
  late final List<FilterCriterion> filterCriterionList;

  bool __ready = false;

  bool get ready => __ready;

  FilterCriteria();

  // Called from outside.
  void _initFilterCriteria({
    required FilterConditionGroupVal baseCriteria,
    required bool isPrecheck,
  }) {
    // LAZY Property:
    __baseCriteria = baseCriteria;
    __fieldBasedJSON = baseCriteria.toFieldBasedJson(throwIfError: true);
    // LAZY Property:
    filterCriterionList = []; // registerSupportedCriteria();

    Map<String, FilterCriterion> baseNameFilterCriterionMap = {};
    Set<String> set2 = {};
    for (FilterCriterion filterCriterion in filterCriterionList) {
      if (baseNameFilterCriterionMap
          .containsKey(filterCriterion.filterCriterionName)) {
        if (isPrecheck) {
          throw FilterCriteriaDuplicateCriterionError(
            criterionBaseName: filterCriterion.filterCriterionName,
            filterCriteriaClassName: getClassNameWithoutGenerics(this),
          );
        } else {
          throw AppError(
            errorMessage:
                "Duplicated criterionBaseName '${filterCriterion.filterCriterionName}'. "
                "@see the ${getClassNameWithoutGenerics(this)}.registerSupportedCriteria() method for details.",
          );
        }
      }
      if (set2.contains(filterCriterion.filterFieldName)) {
        if (isPrecheck) {
          throw FilterCriteriaDuplicateFieldError(
            field: filterCriterion.filterFieldName,
            filterCriteriaClassName: getClassNameWithoutGenerics(this),
          );
        } else {
          throw AppError(
            errorMessage:
                "Duplicated jsonCriterionName '${filterCriterion.filterFieldName}'. "
                "@see the ${getClassNameWithoutGenerics(this)}.registerSupportedCriteria() method for details.",
          );
        }
      }
      baseNameFilterCriterionMap[filterCriterion.filterCriterionName] =
          filterCriterion;
      set2.add(filterCriterion.filterFieldName);
    }
    __ready = true;
  }

  @override
  bool operator ==(Object other) {
    if (other is! FilterCriteria) {
      return false;
    }
    return __fieldBasedJSON == other.__fieldBasedJSON;
  }

  @override
  int get hashCode => __fieldBasedJSON.hashCode;
}
