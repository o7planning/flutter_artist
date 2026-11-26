part of '../../core.dart';

class ScalarQueryResult<
ID extends Comparable, //
VALUE extends Identifiable<ID>>
    extends ExecutionUnitResult<ScalarQueryPrecheck> {
  bool isFilterError = false;

  ScalarQueryResult._({required super.precheck});

  void _setFilterError() {
    // _setPrecheck(ScalarQueryPrecheck.filterError);
    isFilterError = true;
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    if (isFilterError) {
      return false;
    }
    return errorInfo == null;
  }
}
