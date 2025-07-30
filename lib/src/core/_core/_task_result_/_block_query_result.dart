part of '../code.dart';

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

  void _setAppError({required AppError appError, StackTrace? stackTrace}) {
    _appError = appError;
    _stackTrace = stackTrace;
  }

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    if (_appError != null) {
      return false;
    }
    return true;
  }
}
