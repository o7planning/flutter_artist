part of '../../core.dart';

class FilterFieldNameObj {
  final String fieldName;

  FilterFieldNameObj.parse({required this.fieldName}) {
    if (!NameUtils.isValidFilterFieldName(fieldName)) {
      throw FilterCriterionFieldNameInvalidError(fieldName: fieldName);
    }
  }
}
