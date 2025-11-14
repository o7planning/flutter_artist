import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/_filter_error_method.dart';

class FilterTempError {
  final FilterErrorMethod filterErrorMethod;
  final AppError error;
  final StackTrace stackTrace;
  final String? propName;

  FilterTempError({
    required this.propName,
    required this.filterErrorMethod,
    required Object error,
    required this.stackTrace,
  }) : error = ErrorUtils.toAppError(error);
}
