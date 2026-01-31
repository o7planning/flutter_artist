part of '../core.dart';

abstract class FilterCriteria {
  late final String __jsonCriteria;

  late final FilterConditionGroupVal baseCriteria;
  late final List<Criterionable> criterionableList;

  bool __ready = false;

  bool get ready => __ready;

  String get jsonCriteria {
    return __jsonCriteria;
  }

  FilterCriteria();

  // Called from outside.
  void _initFilterCriteria({
    required FilterConditionGroupVal baseCriteria,
    required bool isPrecheck,
  }) {
    // LAZY Property:
    criterionableList = registerSupportedCriteria();
    // LAZY Property:
    this.baseCriteria = baseCriteria;
    Map<String, Criterionable> baseNameCriterionableMap = {};
    Set<String> set2 = {};
    for (Criterionable criterionable in criterionableList) {
      if (baseNameCriterionableMap
          .containsKey(criterionable.criterionBaseName)) {
        if (isPrecheck) {
          throw DuplicateCriterionableDefError(
            criterionBaseName: criterionable.criterionBaseName,
            filterCriteriaClassName: getClassNameWithoutGenerics(this),
          );
        } else {
          throw AppError(
            errorMessage:
                "Duplicated criterionBaseName '${criterionable.criterionBaseName}'. "
                "@see the ${getClassNameWithoutGenerics(this)}.registerSupportedCriteria() method for details.",
          );
        }
      }
      if (set2.contains(criterionable.jsonCriterionName)) {
        if (isPrecheck) {
          throw DuplicateCriterionableFieldError(
            field: criterionable.jsonCriterionName,
            filterCriteriaClassName: getClassNameWithoutGenerics(this),
          );
        } else {
          throw AppError(
            errorMessage:
                "Duplicated jsonCriterionName '${criterionable.jsonCriterionName}'. "
                "@see the ${getClassNameWithoutGenerics(this)}.registerSupportedCriteria() method for details.",
          );
        }
      }
      baseNameCriterionableMap[criterionable.criterionBaseName] = criterionable;
      set2.add(criterionable.jsonCriterionName);
    }
    // LAZY Property:
    __jsonCriteria = baseCriteria.toJsonForBackend(
      criterionableMap: baseNameCriterionableMap,
    );
    __ready = true;
  }

  List<Criterionable> registerSupportedCriteria();

  @override
  bool operator ==(Object other) {
    if (other is! FilterCriteria) {
      return false;
    }
    return __jsonCriteria == other.__jsonCriteria;
  }

  @override
  int get hashCode => __jsonCriteria.hashCode;
}
