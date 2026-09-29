import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../core/enums/_enums.dart';

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
  }) : error = FaErrorUtils.toAppError(error);
}
