import '_filter_model_register_error.dart';

class FilterConditionGroupDuplicateNameError extends FilterModelRegisterError {
  final String groupName;

  FilterConditionGroupDuplicateNameError({required this.groupName});

  @override
  String toString() {
    return "Duplicated ConditionGroupDef Group Name: $groupName";
  }
}
