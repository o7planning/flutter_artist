part of '../../core.dart';

/// Execution unit result representing the outcome of a [LovModel] query operation.
class LovQueryResult<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>>
    extends ExecutionUnitResult<LovQueryPrecheck> {
  bool _isFilterError = false;

  /// Indicates whether the query failed due to a [FilterModel] error.
  bool get isFilterError => _isFilterError;

  LovQueryResult._({
    super.precheck,
    super.errorInfo,
  });

  LovQueryResult._busy() : super(precheck: LovQueryPrecheck.busy);

  LovQueryResult._precheckFail({
    required LovQueryPrecheck precheck,
  }) : super(precheck: precheck);

  void _setFilterError() {
    _isFilterError = true;
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    if (_isFilterError) {
      return false;
    }
    if (errorInfo != null) {
      return false;
    }
    return true;
  }
}
