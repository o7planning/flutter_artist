part of '../../flutter_artist.dart';

class ItemDeletionResult<ITEM> extends ActionResult {
  final BlockItemDeletionPrecheck? precheck;
  AppError? _appError;
  ITEM? _candidateItem;
  ITEM? _deletedItem;
  ITEM? _failedItem;

  ITEM? get candidateItem => _candidateItem;
  ITEM? get deletedItem => _deletedItem;
  ITEM? get failedItem => _failedItem;
  AppError? get error => _appError;

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

  void _setCandidateItem({required ITEM candidateItem}) {
    _candidateItem = _candidateItem;
  }

  void _setDeletedItem({required ITEM deletedItem}) {
    _deletedItem = deletedItem;
  }

  void _setFailedItem({required ITEM failedItem, required AppError appError}) {
    _failedItem = failedItem;
    _appError = appError;
  }
}
