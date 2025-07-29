part of '../_fa_core.dart';

class BlockQueryResult extends ActionResult {
  BlockQueryPrecheck? _precheck;

  BlockQueryPrecheck? get precheck => _precheck;

  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  BlockQueryResult._();

  BlockQueryResult._queryBlockedTemporarily()
      : _precheck = BlockQueryPrecheck.queryBlockedTemporarily;

  BlockQueryResult._noCurrentPagination()
      : _precheck = BlockQueryPrecheck.noCurrentPagination;

  BlockQueryResult._noPreviousPage()
      : _precheck = BlockQueryPrecheck.noPreviousPage;

  BlockQueryResult._noNextPage() //
      : _precheck = BlockQueryPrecheck.noNextPage;

  void _setFilterError() {
    _precheck = BlockQueryPrecheck.filterError;
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
