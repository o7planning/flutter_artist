import 'package:flutter_artist_core/flutter_artist_core.dart';

class FormMultiOptMsMismatchError {
  final String propName;
  final Type definedPropType;
  final dynamic actualValue;

  FormMultiOptMsMismatchError({
    required this.propName,
    required this.definedPropType,
    required this.actualValue,
  });

  AppError toAppError({required dynamic formModelName}) {
    return AppError(
      errorMessage:
          "The input field type of `$propName` does not match between the definition and the actual type. "
          "Defined as `Multi Selection`, but is actually `Single Selection` or something else. "
          "Check `$formModelName` and its `FormPanel` for details.",
    );
  }
}
