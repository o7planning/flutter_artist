part of '../core.dart';

class FilterModelDataLoadResult
    extends ExecutionUnitResult<FilterModelDataLoadPrecheck> {
  FilterModelDataLoadResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
