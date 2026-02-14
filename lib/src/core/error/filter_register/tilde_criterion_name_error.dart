import 'filter_criterion_register_error.dart';

class TildeCriterionNameError extends FilterCriterionRegisterError {
  final String tildeCriterionName;

  TildeCriterionNameError({required this.tildeCriterionName});

  @override
  String toString() {
    return "Invalid Criterion Name Tilde: $tildeCriterionName";
  }
}
