import 'filter_criterion_register_error.dart';

class DuplicateCriterionDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;

  DuplicateCriterionDefError({required this.criterionBaseName});
}
