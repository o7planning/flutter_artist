import 'filter_criterion_register_error.dart';

class DuplicateConditionGroupDefError extends FilterCriterionRegisterError {
  final String groupName;

  DuplicateConditionGroupDefError({required this.groupName});

  @override
  String toString() {
    return "Duplicated ConditionGroupDef Group Name: $groupName";
  }
}
