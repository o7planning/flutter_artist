part of '../flutter_artist.dart';

class FormUtils {
  static void removeItemFromList<E, ID>({
    required List<E> items,
    required E removeItem,
    required ID Function(E item) getItemId,
  }) {
    int idx = items.indexWhere((it) {
      return getItemId(it) == getItemId(removeItem);
    });
    if (idx != -1) {
      items.removeAt(idx);
    }
  }

  static void insertOrReplaceItemInList<E, ID>({
    required List<E> items,
    required E item,
    required ID Function(E item) getItemId,
  }) {
    int idx = items.indexWhere((it) {
      return getItemId(it) == getItemId(item);
    });
    if (idx == -1) {
      items.insert(0, item);
    } else {
      items[idx] = item;
    }
  }

  static E? findSiblingItemInList<E, ID>({
    required List<E> items,
    required E item,
    required ID Function(E item) getItemId,
  }) {
    int idx = items.indexWhere((e) {
      return getItemId(e) == getItemId(item);
    });
    if (idx == -1) {
      if (items.isNotEmpty) {
        return items[0];
      }
      return null;
    } else {
      if (idx + 1 < items.length) {
        return items[idx + 1];
      } else if (idx - 1 >= 0) {
        return items[idx - 1];
      }
      return null;
    }
  }
}
