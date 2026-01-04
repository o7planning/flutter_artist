class DuplicateFilterCriterionError {
  final String criterionName;

  DuplicateFilterCriterionError({required this.criterionName});

  @override
  String toString() {
    return "Duplicated Criterion Name: $criterionName";
  }
}

class DuplicateFilterCriterionPlusError {
  final String criterionNamePlus;

  DuplicateFilterCriterionPlusError({required this.criterionNamePlus});

  @override
  String toString() {
    return "Duplicated Criterion Name Plus: $criterionNamePlus";
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

class CriterionNamePlusError {
  final String criterionNamePlus;

  CriterionNamePlusError({required this.criterionNamePlus});

  @override
  String toString() {
    return "Invalid Criterion Name Plus: $criterionNamePlus";
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
