part of '../core.dart';

class BlockItemDeletionResult<ITEM>
    extends TaskResult<BlockItemDeletionPrecheck> {
  ITEM? _candidateItem;
  ITEM? _deletedItem;
  ITEM? _failedItem;

  ITEM? get candidateItem => _candidateItem;

  ITEM? get deletedItem => _deletedItem;

  ITEM? get failedItem => _failedItem;

  BlockItemDeletionResult({
    required ITEM? candidateItem,
    super.precheck,
    super.errorInfo,
  }) : _candidateItem = candidateItem;

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    if (errorInfo != null) {
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
    required ErrorInfo errorInfo,
  }) {
    _failedItem = failedItem;
    _setErrorInfo(errorInfo: errorInfo);
  }
}
