import '_filter_model_register_error.dart';

class TildeFilterCriterionSuffixInvalidError extends FilterModelRegisterError {
  final String tildeSuffix;

  TildeFilterCriterionSuffixInvalidError({required this.tildeSuffix});

  @override
  String toString() {
    return "Invalid Tilde Suffix: $tildeSuffix";
  }
}
