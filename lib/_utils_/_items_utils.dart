part of '../flutter_artist.dart';

bool _isListContainItem<I, ID>({
  required List<I> items,
  required I item,
  required ID Function(I it) getItemId,
}) {
  ID itemId = getItemId(item);
  for (I it in items) {
    ID itId = getItemId(it);
    if (itId == itemId) {
      return true;
    }
  }
  return false;
}

I? _getItemBySameItemId<I, ID>({
  required List<I> items,
  required I sameItem,
  required ID Function(I it) getItemId,
}) {
  ID sameItemId = getItemId(sameItem);
  for (I it in items) {
    ID itId = getItemId(it);
    if (itId == sameItemId) {
      return it;
    }
  }
  return null;
}
