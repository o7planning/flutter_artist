part of '../../flutter_artist.dart';

class ItemDeletionResult<ITEM> extends ActionResult {
  final BlockItemDeletionPrecheck? precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;
  StackTrace? get stackTrace => _stackTrace;

  ITEM? _candidateItem;
  ITEM? _deletedItem;
  ITEM? _failedItem;

  ITEM? get candidateItem => _candidateItem;
  ITEM? get deletedItem => _deletedItem;
  ITEM? get failedItem => _failedItem;

  ItemDeletionResult({
    required ITEM? candidateItem,
    this.precheck,
    StackTrace? stackTrace,
  })  : _candidateItem = candidateItem,
        _stackTrace = stackTrace;

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
    _appError = appError;
    _stackTrace = stackTrace;
  }
}
