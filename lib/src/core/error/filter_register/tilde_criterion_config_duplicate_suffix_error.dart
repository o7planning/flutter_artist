import '_filter_model_register_error.dart';

class TildeCriterionConfigDuplicationSuffixError
    extends FilterModelRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  TildeCriterionConfigDuplicationSuffixError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
}
