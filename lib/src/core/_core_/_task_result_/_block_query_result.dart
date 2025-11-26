part of '../core.dart';

class BlockQueryResult extends TaskResult<BlockQueryPrecheck> {
  BlockQueryResult._();

  BlockQueryResult._queryBlockedTemporarily()
      : super(precheck: BlockQueryPrecheck.queryBlockedTemporarily);

  BlockQueryResult._noCurrentPagination()
      : super(precheck: BlockQueryPrecheck.noCurrentPagination);

  BlockQueryResult._noPreviousPage()
      : super(precheck: BlockQueryPrecheck.noPreviousPage);

  BlockQueryResult._noNextPage() //
      : super(precheck: BlockQueryPrecheck.noNextPage);

  void _setFilterError() {
    _setPrecheck(BlockQueryPrecheck.filterError);
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    if (_errorInfo != null) {
      return false;
    }
    return true;
  }
}
