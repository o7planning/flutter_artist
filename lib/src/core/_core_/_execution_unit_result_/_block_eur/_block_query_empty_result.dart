part of '../../core.dart';

/// Execution unit result representing the outcome of a [Block.queryEmpty] operation.
class BlockQueryEmptyResult<ID extends Comparable,
        ITEM extends Identifiable<ID>, ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL,
        BlockQueryEmptyPrecheck> {
  bool _isFilterError = false;

  /// Indicates whether the empty query failed due to a [FilterModel] error.
  bool get isFilterError => _isFilterError;

  BlockQueryEmptyResult._({
    super.precheck,
    super.errorInfo,
    bool isFilterError = false,
  }) : _isFilterError = isFilterError;

  BlockQueryEmptyResult._busy() : super(precheck: BlockQueryEmptyPrecheck.busy);

  BlockQueryEmptyResult._precheckFail({
    required BlockQueryEmptyPrecheck precheck,
  }) : super(precheck: precheck);

  /// Creates a [BlockQueryEmptyResult] mirroring the execution outcome
  /// of an internal [BlockQueryResult] produced by empty-query execution.
  factory BlockQueryEmptyResult._fromQueryResult(
    BlockQueryResult<ID, ITEM, ITEM_DETAIL> queryResult,
  ) {
    return BlockQueryEmptyResult._(
      errorInfo: queryResult.errorInfo,
      isFilterError: queryResult._isFilterError,
    );
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    if (_isFilterError) {
      return false;
    }
    return errorInfo == null;
  }
}
