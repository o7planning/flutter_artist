abstract class FilterCriterionRegisterError {
  //
}

class DuplicateCriterionableDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String filterCriteriaClassName;

  DuplicateCriterionableDefError({
    required this.criterionBaseName,
    required this.filterCriteriaClassName,
  });
}

class DuplicateCriterionableFieldError extends FilterCriterionRegisterError {
  final String field;
  final String filterCriteriaClassName;

  DuplicateCriterionableFieldError({
    required this.field,
    required this.filterCriteriaClassName,
  });
}

class DuplicateCriterionDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;

  DuplicateCriterionDefError({required this.criterionBaseName});
}

class DuplicateFilterConditionDefError extends FilterCriterionRegisterError {
  final String criterionNameTilde;
  final String? groupName;

  DuplicateFilterConditionDefError({
    required this.criterionNameTilde,
    required this.groupName,
  });

  @override
  String toString() {
    return "Duplicated ConditionDef Criterion Name Tilde: $criterionNameTilde";
  }
}

class DuplicateConditionGroupDefError extends FilterCriterionRegisterError {
  final String groupName;

  DuplicateConditionGroupDefError({required this.groupName});

  @override
  String toString() {
    return "Duplicated ConditionGroupDef Group Name: $groupName";
  }
}

class FilterCriterionNotFoundError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String criterionNameTilde;

  FilterCriterionNotFoundError({
    required this.criterionBaseName,
    required this.criterionNameTilde,
  });

  @override
  String toString() {
    return "Criterion Name: $criterionBaseName not found!";
  }
}

class CriterionNameTildeError extends FilterCriterionRegisterError {
  final String criterionNameTilde;

  CriterionNameTildeError({required this.criterionNameTilde});

  @override
  String toString() {
    return "Invalid Criterion Name Tilde: $criterionNameTilde";
  }
}

class CriterionBaseNameError extends FilterCriterionRegisterError {
  final String criterionBaseName;

  CriterionBaseNameError({required this.criterionBaseName});

  @override
  String toString() {
    return "Invalid Criterion Base Name: $criterionBaseName";
  }
}
