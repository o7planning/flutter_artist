import 'filter_criterion_register_error.dart';

class DuplicateFilterFieldError extends FilterCriterionRegisterError {
  final String field;
  final String filterCriteriaClassName;

  DuplicateFilterFieldError({
    required this.field,
    required this.filterCriteriaClassName,
  });
}
