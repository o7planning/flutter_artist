part of '_enums.dart';

enum FilterErrorMethod {
  // OLD: specifyDefaultPlainCriterion Values
  specifyDefaultValuesForPlainTildeCriteria,

  // OLD: specifyDefaultValueForManagedOptTildeCriterion
  specifyDefaultValueForManagedOptTildeCriterion,

  // OLD: getPlainCriterionValuesFromFilterPatch
  extractPatchValuesForPlainTildeCriteria,

  // OLD: getManagedOptCriterionValueFromFilterPatch
  extractPatchValueForManagedOptTildeCriterion,
  createNewFilterCriteria,
  performLoadManagedOptTildeCriterionXData,
  //
  unknown;
}
