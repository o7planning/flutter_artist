import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../utils/_class_utils.dart';

class FilterCriterionTypeMismatchError {
  final String tildeCriterionName;
  final Type definedTildeCriterionType;
  final dynamic actualValue;

  FilterCriterionTypeMismatchError({
    required this.tildeCriterionName,
    required this.definedTildeCriterionType,
    required this.actualValue,
  });

  AppError toAppError({required dynamic filterModelName}) {
    return AppError(
      errorMessage:
          "The data type of `$tildeCriterionName` does not match between the definition and the actual type. "
          "Defined as `${getTypeNameWithoutGenerics(definedTildeCriterionType)}`, "
          "actually `${getTypeNameWithoutGenerics(actualValue.runtimeType)}`. "
          "Check `$filterModelName` and its `FilterPanel` for details.",
    );
  }
}
