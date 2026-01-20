class DuplicateCriterionDefError {
  final String criterionName;

  DuplicateCriterionDefError({required this.criterionName});
}

class DuplicateFilterCriterionError {
  final String criterionNameTilde;

  DuplicateFilterCriterionError({required this.criterionNameTilde});
}

class DuplicateFilterCriterionXError {
  final String criterionNameTilde;
  final String? groupName;

  DuplicateFilterCriterionXError({
    required this.criterionNameTilde,
    required this.groupName,
  });

  @override
  String toString() {
    return "Duplicated Criterion Name Tilde: $criterionNameTilde";
  }
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

class CriterionNameTildeError {
  final String criterionNameTilde;

  CriterionNameTildeError({required this.criterionNameTilde});

  @override
  String toString() {
    return "Invalid Criterion Name Tilde: $criterionNameTilde";
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
