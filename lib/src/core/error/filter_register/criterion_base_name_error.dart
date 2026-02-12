import 'filter_criterion_register_error.dart';

class CriterionBaseNameError extends FilterCriterionRegisterError {
  final String criterionBaseName;

  CriterionBaseNameError({required this.criterionBaseName});

  @override
  String toString() {
    return "Invalid Criterion Base Name: $criterionBaseName";
  }
}
