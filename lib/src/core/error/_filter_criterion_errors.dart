abstract class FilterCriterionRegisterError {
  //
}

class FilterFieldNoConverterError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final Type dataType;

  FilterFieldNoConverterError({
    required this.criterionBaseName,
    required this.dataType,
  });
}

class DuplicateFilterCriterionError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String filterCriteriaClassName;

  DuplicateFilterCriterionError({
    required this.criterionBaseName,
    required this.filterCriteriaClassName,
  });
}

class DuplicateFilterFieldError extends FilterCriterionRegisterError {
  final String field;
  final String filterCriteriaClassName;

  DuplicateFilterFieldError({
    required this.field,
    required this.filterCriteriaClassName,
  });
}

class DuplicateCriterionDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;

  DuplicateCriterionDefError({required this.criterionBaseName});
}

class DuplicateCriterionFieldDefError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String fieldName;

  DuplicateCriterionFieldDefError({
    required this.criterionBaseName,
    required this.fieldName,
  });
}

// ????
class CriterionTildeDefInvalidSuffixError
    extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  CriterionTildeDefInvalidSuffixError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
}

// ????
class CriterionTildeDefDuplicationError
    extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final String tildeSuffix;

  CriterionTildeDefDuplicationError({
    required this.tildeSuffix,
    required this.criterionBaseName,
  });
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

class TildeSuffixError extends FilterCriterionRegisterError {
  final String tildeSuffix;

  TildeSuffixError({required this.tildeSuffix});

  @override
  String toString() {
    return "Invalid Tilde Suffix: $tildeSuffix";
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

class FilterFieldNameError extends FilterCriterionRegisterError {
  final String fieldName;

  FilterFieldNameError({required this.fieldName});

  @override
  String toString() {
    return "Invalid Field Name: $fieldName";
  }
}
