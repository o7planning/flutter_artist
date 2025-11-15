part of '../core.dart';

class FilterModelDataLoadResult
    extends TaskResult<FilterModelDataLoadPrecheck> {
  FilterModelDataLoadResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
