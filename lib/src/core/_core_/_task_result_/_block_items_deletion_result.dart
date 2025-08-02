part of '../core.dart';

class BlockItemsDeletionResult<ITEM>
    extends TaskResult<BlockItemsDeletionPrecheck> {
  final List<ITEM> _candidateItems;
  final List<ITEM> _deletedItems = [];
  final List<FailedItemDeletion<ITEM>> _failedItemDeletions = [];

  List<ITEM> get candidateItems => [..._candidateItems];

  List<ITEM> get deletedItems => [..._deletedItems];

  List<FailedItemDeletion<ITEM>> get failedItemDeletions =>
      [..._failedItemDeletions];

  BlockItemsDeletionResult({
    required List<ITEM> candidateItems,
    super.precheck,
    super.stackTrace,
  }) : _candidateItems = candidateItems;

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

  void _setCandidateItems({required List<ITEM> candidateItems}) {
    _candidateItems
      ..clear()
      ..addAll(candidateItems);
  }

  void _addDeletedItem({
    required ITEM deletedItem,
  }) {
    _deletedItems.add(deletedItem);
  }

  void _addFailedItem({
    required ITEM failedItem,
    required Object error,
    required StackTrace? stackTrace,
  }) {
    AppError appError = ErrorUtils.toAppError(error);
    //
    _failedItemDeletions.add(
      FailedItemDeletion(
        failedItem: failedItem,
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      ),
    );
  }
}

class FailedItemDeletion<ITEM> {
  final ITEM failedItem;
  final AppError appError;
  final StackTrace? stackTrace;

  FailedItemDeletion({
    required this.failedItem,
    required this.appError,
    required this.stackTrace,
  });
}
