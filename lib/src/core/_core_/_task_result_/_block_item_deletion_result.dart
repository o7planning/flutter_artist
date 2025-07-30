part of '../core.dart';

class ItemDeletionResult<ITEM> extends TaskResult<BlockItemDeletionPrecheck> {
  ITEM? _candidateItem;
  ITEM? _deletedItem;
  ITEM? _failedItem;

  ITEM? get candidateItem => _candidateItem;

  ITEM? get deletedItem => _deletedItem;

  ITEM? get failedItem => _failedItem;

  ItemDeletionResult({
    required ITEM? candidateItem,
    super.precheck,
    super.stackTrace,
  }) : _candidateItem = candidateItem;

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    if (error != null) {
      return false;
    }
    // TODO: Xem lai.
    return _deletedItem != null;
  }

  void _setCandidateItem({required ITEM candidateItem}) {
    _candidateItem = _candidateItem;
  }

  void _setDeletedItem({required ITEM deletedItem}) {
    _deletedItem = deletedItem;
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
