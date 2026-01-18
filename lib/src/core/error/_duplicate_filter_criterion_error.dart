class DuplicateFilterCriterionError {
  final String criterionNameX;

  DuplicateFilterCriterionError({required this.criterionNameX});
}

class DuplicateFilterCriteriaGroupError {
  final String groupName;

  DuplicateFilterCriteriaGroupError({required this.groupName});

  @override
  String toString() {
    return "Duplicated Group Name: $groupName";
  }
}

class FilterCriterionNotFoundError {
  final String criterionName;

  FilterCriterionNotFoundError({required this.criterionName});

  @override
  String toString() {
    return "Criterion Name: $criterionName not found!";
  }
}

class CriterionNameXError {
  final String criterionNameX;

  CriterionNameXError({required this.criterionNameX});

  @override
  String toString() {
    return "Invalid Criterion Name X: $criterionNameX";
  }
}

class CriterionBaseNameError {
  final String criterionBaseName;

  CriterionBaseNameError({required this.criterionBaseName});

  @override
  String toString() {
    return "Invalid Criterion Base Name: $criterionBaseName";
  }
}
