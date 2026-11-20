part of '_enums.dart';

enum FilterErrorMethod {
  // OLD: specifyDefaultSimpleCriterion Values
  specifyDefaultValuesForSimpleTildeCriteria,

  // OLD: specifyDefaultValueForMultiOptTildeCriterion
  specifyDefaultValueForMultiOptTildeCriterion,

  // OLD: getSimpleCriterionValuesFromFilterPatch
  extractPatchValuesForSimpleTildeCriteria,

  // OLD: getMultiOptCriterionValueFromFilterPatch
  extractPatchValueForMultiOptTildeCriterion,
  createNewFilterCriteria,
  performLoadMultiOptTildeCriterionXData,
  //
  unknown;
}
