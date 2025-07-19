part of '../../flutter_artist.dart';

class ItemDeletionResult<ITEM> extends ActionResult {
  final BlockItemDeletionPrecheck? precheck;
  AppError? _appError;
  ITEM? _candidateItem;
  ITEM? _deletedItem;
  ITEM? _failedItem;

  ItemDeletionResult({required ITEM? candidateItem, this.precheck})
      : _candidateItem = candidateItem;

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    // TODO: Xem lai.
    return _deletedItem != null;
  }

  void setCandidateItem({required ITEM candidateItem}) {
    _candidateItem = _candidateItem;
  }

  void setDeletedItem({required ITEM deletedItem}) {
    _deletedItem = deletedItem;
  }

  void setFailedItem({required ITEM failedItem, required AppError appError}) {
    _failedItem = failedItem;
    _appError = appError;
  }
}
