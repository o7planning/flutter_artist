part of '_enums.dart';

enum FormErrorMethod {
  performLoadMultiOptPropXData,
  //
  extractSimplePropValuesFromItemDetail,
  extractMultiOptPropValueFromItemDetail,

  // OLD: getMultiOptPropValueFromFormInput
  extractPatchValueForMultiOptProp,

  // OLD: getSimplePropValuesFromFormInput
  extractPatchValuesForSimpleProps,

  // OLD: specifyDefaultSimplePropValues
  specifyDefaultValuesForSimpleProps,

  // OLD: specifyDefaultMultiOptPropValue
  specifyDefaultValueForMultiOptProp,
  //
  unknown;
}
