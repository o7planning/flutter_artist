part of '../flutter_artist.dart';

class CurrentItemSelectionResult<ITEM> {
  final bool success;
  final ITEM? candidateItem;
  final ITEM? oldCurrentItem;
  final ITEM? currentItem;

  CurrentItemSelectionResult({
    required this.success,
    required this.candidateItem,
    required this.oldCurrentItem,
    required this.currentItem,
  });

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

class ItemDeletionResult {
  //
}
