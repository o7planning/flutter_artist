part of '../core.dart';

class ScalarQueryResult extends TaskResult<ScalarQueryPrecheck> {
  ScalarQueryResult({required super.precheck});

  void _setFilterError() {
    _setPrecheck(ScalarQueryPrecheck.filterError);
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
