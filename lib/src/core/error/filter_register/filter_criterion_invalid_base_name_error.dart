import '_filter_model_register_error.dart';

class FilterCriterionInvalidBaseNameError extends FilterModelRegisterError {
  final String criterionBaseName;

  FilterCriterionInvalidBaseNameError({required this.criterionBaseName});

  @override
  String toString() {
    return "Invalid Criterion Base Name: $criterionBaseName";
  }
}
