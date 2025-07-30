part of '../../_fa_core.dart';

class ItemsDeletionResult<ITEM> extends TaskResult<BlockItemDeletionPrecheck> {
  ITEM? _deletedItem;
  ITEM? _failedItem;

  ITEM? get deletedItem => _deletedItem;

  ITEM? get failedItem => _failedItem;

  ItemsDeletionResult({
    super.precheck,
    super.stackTrace,
  });

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
    _setAppError(appError: appError, stackTrace: stackTrace);
  }
}
