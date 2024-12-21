part of '../flutter_artist.dart';

bool _isListContainItem<I>({
  required List<I> items,
  required I item,
  required String Function(I it) getItemIdAsString,
}) {
  String itemId = getItemIdAsString(item);
  for (I it in items) {
    String itId = getItemIdAsString(it);
    if (itId == itemId) {
      return true;
    }
  }
  return false;
}

I? _getItemBySameItemId<I>({
  required List<I> items,
  required I sameItem,
  required String Function(I it) getItemIdAsString,
}) {
  String sameItemId = getItemIdAsString(sameItem);
  for (I it in items) {
    String itId = getItemIdAsString(it);
    if (itId == sameItemId) {
      return it;
    }
  }
  return null;
}
