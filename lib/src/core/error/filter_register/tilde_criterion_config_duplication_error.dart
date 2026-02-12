import 'filter_criterion_register_error.dart';

class TildeCriterionConfigDuplicationError
    extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  TildeCriterionConfigDuplicationError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
}
