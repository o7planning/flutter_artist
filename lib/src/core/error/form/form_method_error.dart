import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../_core_/_enums_/_enums.dart';

class FormMethodError {
  final FormErrorMethod formErrorMethod;
  final AppError error;
  final StackTrace stackTrace;
  final String? propName;

  FormMethodError({
    required this.propName,
    required this.formErrorMethod,
    required Object error,
    required this.stackTrace,
  }) : error = FaErrorUtils.toAppError(error);
}
