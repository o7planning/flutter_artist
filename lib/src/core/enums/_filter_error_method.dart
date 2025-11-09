enum FilterErrorMethod {
  // OLD: specifyDefaultSimpleCriterion Values
  specifyDefaultValuesForSimpleCriteria,

  // OLD: specifyDefaultValueForMultiOptCriterion
  specifyDefaultValueForMultiOptCriterion,

  // OLD: getSimpleCriterionValuesFromFilterInput
  getUpdatedValuesForSimpleCriteria,

  // OLD: getMultiOptCriterionValueFromFilterInput
  getUpdatedValueForMultiOptCriterion,

  toFilterCriteriaObject,
  
  callApiLoadMultiOptCriterionXData,
  //
  unknown;
}