import 'filter_criterion_register_error.dart';

class TildeSuffixError extends FilterCriterionRegisterError {
  final String tildeSuffix;

  TildeSuffixError({required this.tildeSuffix});

  @override
  String toString() {
    return "Invalid Tilde Suffix: $tildeSuffix";
  }
}
