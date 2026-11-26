part of '_enums.dart';

enum FormErrorMethod {
  performLoadManagedOptPropXData,
  //
  extractPlainPropValuesFromItemDetail,
  extractManagedOptPropValueFromItemDetail,

  // OLD: getManagedOptPropValueFromFormInput
  extractPatchValueForManagedOptProp,

  // OLD: getPlainPropValuesFromFormInput
  extractPatchValuesForPlainProps,

  // OLD: specifyDefaultPlainPropValues
  specifyDefaultValuesForPlainProps,

  // OLD: specifyDefaultManagedOptPropValue
  specifyDefaultValueForManagedOptProp,
  //
  unknown;
}
