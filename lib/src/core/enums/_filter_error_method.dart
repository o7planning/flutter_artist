enum FilterErrorMethod {
  // OLD: specifyDefaultSimpleCriterion Values
  specifyDefaultValuesForSimpleCriteria,

  // OLD: specifyDefaultValueForMultiOptCriterion
  specifyDefaultValueForMultiOptCriterion,

  // OLD: getSimpleCriterionValuesFromFilterInput
  extractUpdateValuesForSimpleCriteria,

  // OLD: getMultiOptCriterionValueFromFilterInput
  extractUpdateValueForMultiOptCriterion,
  toFilterCriteriaObject,
  callApiLoadMultiOptCriterionXData,
  //
  unknown;
}
