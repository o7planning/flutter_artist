part of '../_fa_core.dart';

class ScalarQueryResult extends TaskResult<ScalarQueryPrecheck> {
  ScalarQueryResult({required super.precheck});

  void _setFilterError() {
    _setPrecheck(ScalarQueryPrecheck.filterError);
  }

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
