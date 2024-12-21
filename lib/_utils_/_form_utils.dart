part of '../flutter_artist.dart';

class FormUtils {
  static void removeItemFromList<E>({
    required List<E> items,
    required E removeItem,
    required String Function(E item) getItemIdAsString,
  }) {
    int idx = items.indexWhere((it) {
      return getItemIdAsString(it) == getItemIdAsString(removeItem);
    });
    if (idx != -1) {
      items.removeAt(idx);
    }
  }

  static void insertOrReplaceItemInList<E>({
    required List<E> items,
    required E item,
    required String Function(E item) getItemIdAsString,
  }) {
    int idx = items.indexWhere((it) {
      return getItemIdAsString(it) == getItemIdAsString(item);
    });
    if (idx == -1) {
      items.insert(0, item);
    } else {
      items[idx] = item;
    }
  }

  static E? findSiblingItemInList<E>({
    required List<E> items,
    required E item,
    required String Function(E item) getItemIdAsString,
  }) {
    int idx = items.indexWhere((e) {
      return getItemIdAsString(e) == getItemIdAsString(item);
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
