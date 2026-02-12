import 'filter_criterion_register_error.dart';

class FilterFieldNameError extends FilterCriterionRegisterError {
  final String fieldName;

  FilterFieldNameError({required this.fieldName});

  @override
  String toString() {
    return "Invalid Field Name: $fieldName";
  }
}
