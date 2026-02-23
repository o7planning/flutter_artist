import '_filter_model_register_error.dart';

class TildeFilterCriterionBaseCriterionNotFoundError
    extends FilterModelRegisterError {
  final String criterionBaseName;
  final String tildeCriterionName;

  TildeFilterCriterionBaseCriterionNotFoundError({
    required this.criterionBaseName,
    required this.tildeCriterionName,
  });

  @override
  String toString() {
    return "Criterion Name: $criterionBaseName not found!";
  }
}
