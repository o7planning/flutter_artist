part of '../../core.dart';

class ScalarQueryResult extends ExecutionUnitResult<ScalarQueryPrecheck> {
  bool isFilterError = false;

  ScalarQueryResult({required super.precheck});

  void _setFilterError() {
    // _setPrecheck(ScalarQueryPrecheck.filterError);
    isFilterError = true;
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    if (isFilterError != null) {
      return false;
    }
    return errorInfo == null;
  }
}
