import '_filter_model_register_error.dart';

class TildeCriterionConfigInvalidSuffixError extends FilterModelRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  TildeCriterionConfigInvalidSuffixError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
}
