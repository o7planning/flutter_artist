import '_filter_model_register_error.dart';

class FilterCriteriaDuplicateFieldError extends FilterModelRegisterError {
  final String field;
  final String filterCriteriaClassName;

  FilterCriteriaDuplicateFieldError({
    required this.field,
    required this.filterCriteriaClassName,
  });
}
