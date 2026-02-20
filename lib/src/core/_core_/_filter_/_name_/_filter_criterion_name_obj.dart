part of '../../core.dart';

class FilterCriterionNameObj {
  final String criterionBaseName;

  FilterCriterionNameObj.parse({required this.criterionBaseName}) {
    if (!NameUtils.isValidFilterCriterionName(criterionBaseName)) {
      throw FilterCriterionInvalidBaseNameError(
          criterionBaseName: criterionBaseName);
    }
  }
}
