import '_filter_model_register_error.dart';

class FilterCriterionDuplicateFieldNameError extends FilterModelRegisterError {
  final String criterionBaseName;
  final String fieldName;

  FilterCriterionDuplicateFieldNameError({
    required this.criterionBaseName,
    required this.fieldName,
  });
}
