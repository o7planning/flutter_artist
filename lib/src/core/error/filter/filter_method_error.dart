import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../enums/_filter_error_method.dart';

class FilterMethodError {
  final FilterErrorMethod filterErrorMethod;
  final AppError error;
  final StackTrace errorStackTrace;
  final String? tildeCriterionName;

  FilterMethodError({
    required this.tildeCriterionName,
    required this.filterErrorMethod,
    required Object error,
    required this.errorStackTrace,
  }) : error = ErrorUtils.toAppError(error);
}
