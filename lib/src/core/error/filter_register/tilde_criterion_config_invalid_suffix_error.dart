import 'filter_criterion_register_error.dart';

class TildeCriterionConfigInvalidSuffixError
    extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  TildeCriterionConfigInvalidSuffixError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
}
