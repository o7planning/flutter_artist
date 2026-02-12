import 'filter_criterion_register_error.dart';

class DuplicateFilterConditionDefError extends FilterCriterionRegisterError {
  final String tildeCriterionName;
  final String? groupName;

  DuplicateFilterConditionDefError({
    required this.tildeCriterionName,
    required this.groupName,
  });

  @override
  String toString() {
    return "Duplicated ConditionDef Criterion Name Tilde: $tildeCriterionName";
  }
}
