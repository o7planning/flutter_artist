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
  bool success = false;
  ITEM? candidateItem;

  void _initState({
    required ITEM? candidateItem,
  }) {
    this.candidateItem = candidateItem;
  }
}
