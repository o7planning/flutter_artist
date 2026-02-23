import '_filter_model_register_error.dart';

class FilterCriterionFieldNameInvalidError extends FilterModelRegisterError {
  final String fieldName;

  FilterCriterionFieldNameInvalidError({required this.fieldName});

  @override
  String toString() {
    return "Invalid Field Name: $fieldName";
  }
}
