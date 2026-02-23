import '_filter_model_register_error.dart';

class FilterConditionGroupDuplicateTildeError extends FilterModelRegisterError {
  final String tildeCriterionName;
  final String? groupName;

  FilterConditionGroupDuplicateTildeError({
    required this.tildeCriterionName,
    required this.groupName,
  });

  @override
  String toString() {
    return "Duplicated ConditionDef Criterion Name Tilde: $tildeCriterionName";
  }
}
