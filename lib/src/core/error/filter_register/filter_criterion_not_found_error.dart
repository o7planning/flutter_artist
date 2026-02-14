import 'filter_criterion_register_error.dart';

class FilterCriterionNotFoundError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeCriterionName;

  FilterCriterionNotFoundError({
    required this.criterionBaseName,
    required this.tildeCriterionName,
  });

  @override
  String toString() {
    return "Criterion Name: $criterionBaseName not found!";
  }
}
