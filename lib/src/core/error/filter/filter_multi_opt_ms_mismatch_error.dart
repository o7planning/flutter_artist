import 'package:flutter_artist_core/flutter_artist_core.dart';

class FilterMultiOptMsMismatchError {
  final String tildeCriterionName;
  final Type definedTildeCriterionType;
  final dynamic actualValue;

  FilterMultiOptMsMismatchError({
    required this.tildeCriterionName,
    required this.definedTildeCriterionType,
    required this.actualValue,
  });

  AppError toAppError({required dynamic filterModelName}) {
    return AppError(
      errorMessage:
          "The input field type of `$tildeCriterionName` does not match between the definition and the actual type. "
          "Defined as `Multi Selection`, but is actually `Single Selection` or something else. "
          "Check `$filterModelName` and its `FilterPanel` for details.",
    );
  }
}
