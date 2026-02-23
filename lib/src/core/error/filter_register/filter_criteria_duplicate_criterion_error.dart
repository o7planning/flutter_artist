import '_filter_model_register_error.dart';

class FilterCriteriaDuplicateCriterionError extends FilterModelRegisterError {
  final String criterionBaseName;
  final String filterCriteriaClassName;

  FilterCriteriaDuplicateCriterionError({
    required this.criterionBaseName,
    required this.filterCriteriaClassName,
  });
}
