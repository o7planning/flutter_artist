import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../utils/_class_utils.dart';

class FormPropTypeMismatchError {
  final String propName;
  final Type definedPropType;
  final dynamic actualValue;

  FormPropTypeMismatchError({
    required this.propName,
    required this.definedPropType,
    required this.actualValue,
  });

  AppError toAppError({required dynamic formModelName}) {
    return AppError(
      errorMessage:
          "The data type of `$propName` does not match between the definition and the actual type (or value type). "
          "Defined as `${getTypeNameWithoutGenerics(definedPropType)}`, "
          "actually `${getTypeNameWithoutGenerics(actualValue.runtimeType)}`. "
          "Check `$formModelName` and its `FormView` (or its value) for details.",
    );
  }
}
