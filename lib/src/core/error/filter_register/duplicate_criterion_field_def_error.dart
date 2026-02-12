import 'filter_criterion_register_error.dart';

class DuplicateCriterionFieldDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String fieldName;

  DuplicateCriterionFieldDefError({
    required this.criterionBaseName,
    required this.fieldName,
  });
}
