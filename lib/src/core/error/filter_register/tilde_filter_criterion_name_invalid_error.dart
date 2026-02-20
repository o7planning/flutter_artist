import '_filter_model_register_error.dart';

class TildeFilterCriterionNameInvalidError extends FilterModelRegisterError {
  final String tildeCriterionName;

  TildeFilterCriterionNameInvalidError({required this.tildeCriterionName});

  @override
  String toString() {
    return "Invalid Criterion Name Tilde: $tildeCriterionName";
  }
}
