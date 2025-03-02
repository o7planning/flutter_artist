part of '../flutter_artist.dart';

class CurrentItemSelectionResult<ITEM> {
  bool success = true;
  final List<ITEM?> candidateItems = [];
  ITEM? oldCurrentItem;
  ITEM? currentItem;

  CurrentItemSelectionResult();

  void _initState({
    required bool success,
    required ITEM? candidateItem,
    required ITEM? oldCurrentItem,
    required ITEM? currentItem,
  }) {
    this.success = success;
    this.candidateItems.add(candidateItem);
    this.oldCurrentItem = oldCurrentItem;
    this.currentItem = currentItem;
  }

  void _addCandidateItem(ITEM? candidateItem) {
    candidateItems.add(candidateItem);
  }

  ITEM? get firstCandidateItem {
    return candidateItems.firstOrNull;
  }

  ITEM? get lastCandidateItem {
    return candidateItems.lastOrNull;
  }

// bool hasCandidateItemAndSelected() {
//   return candidateItem != null && candidateItem == currentItem;
// }
//
// bool hasNewCurrentItem() {
//   return currentItem != null && currentItem != oldCurrentItem;
// }
//
// bool currentItemChanged() {
//   return currentItem != oldCurrentItem;
// }
}

class ItemDeletionResult<ITEM> {

  List<ITEM> candidateItems =[];
  List<ITEM> deletedItems =[];
  List<ITEM> failedItems = [];


  void addCandidateItem(ITEM item) {
    candidateItems.add(item);
  }

  void addDeletedItem(ITEM item) {
    deletedItems.add(item);
  }

  void addDFailedItem(ITEM item) {
    failedItems.add(item);
  }
}

class QueryResult {
  bool success = true;
}


class ScalarQueryResult {
  bool success = true;
}