import 'filter_criterion_register_error.dart';

class DuplicateFilterCriterionError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String filterCriteriaClassName;

  DuplicateFilterCriterionError({
    required this.criterionBaseName,
    required this.filterCriteriaClassName,
  });
}
