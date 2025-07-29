part of '../_fa_core.dart';

class ItemsDeletionResult<ITEM> extends ActionResult {
  final BlockItemDeletionPrecheck? precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  ITEM? _deletedItem;
  ITEM? _failedItem;

  ITEM? get deletedItem => _deletedItem;

  ITEM? get failedItem => _failedItem;

  ItemsDeletionResult({
    this.precheck,
    StackTrace? stackTrace,
  }) : _stackTrace = stackTrace;

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    if (_appError != null) {
      return false;
    }
    // TODO: Xem lai.
    return _deletedItem != null;
  }

  void _setFailedItem({
    required ITEM failedItem,
    required AppError appError,
    required StackTrace? stackTrace,
  }) {
    _failedItem = failedItem;
    _appError = appError;
    _stackTrace = stackTrace;
  }
}
