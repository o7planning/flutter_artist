part of '../../core.dart';

/// Execution unit result representing the outcome of [FilterModel.query]
/// or [FilterModel.queryAll].
class FilterModelQueryResult
    extends ExecutionUnitResult<FilterModelQueryPrecheck> {
  FilterModelQueryResult({
    super.precheck,
    super.errorInfo,
  });

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
