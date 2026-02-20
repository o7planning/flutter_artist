import '_filter_model_register_error.dart';

class FilterCriterionDuplicateNameError extends FilterModelRegisterError {
  final String criterionBaseName;

  FilterCriterionDuplicateNameError({required this.criterionBaseName});
}
