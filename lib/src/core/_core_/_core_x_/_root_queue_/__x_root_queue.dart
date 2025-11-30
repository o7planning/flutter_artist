part of '../../core.dart';

class _XRootQueue {
  final XStorage _xStorage = XStorage();

  //
  // LinkedHashMap<String fullName, XRootQueueItem>().
  //
  final __xRootQueueItemMap = <String, XRootQueueItem>{};

  bool get isEmpty {
    if (_xStorage.isNotEmpty) {
      return false;
    }
    for (XRootQueueItem item in __xRootQueueItemMap.values) {
      if (!item.isEmptyTask()) {
        return false;
      }
    }
    return true;
  }

  bool get isNotEmpty => !isEmpty;

  void clear() {
    // TODO: Remove.
  }

  bool hasNext() {
    return isNotEmpty;
  }

  _TaskUnit? getNextTaskUnit() {
    _TaskUnit? tu = _xStorage._getNextTaskUnit();
    if (tu != null) {
      return tu;
    }
    while (true) {
      String? firstRootQueueItemName = __xRootQueueItemMap.keys.firstOrNull;
      if (firstRootQueueItemName == null) {
        return null;
      }
      XRootQueueItem rootQueueItem =
          __xRootQueueItemMap[firstRootQueueItemName]!;
      if (rootQueueItem.isEmptyTask()) {
        __xRootQueueItemMap.remove(firstRootQueueItemName);
        continue;
      }
      if (rootQueueItem is XShelf) {
        return rootQueueItem._getNextTaskUnit()!;
      } else if (rootQueueItem is XActivity) {
        return rootQueueItem._getNextTaskUnit()!;
      } else {
        throw "TODO";
      }
    }
  }

  void _addStorageSilentActionTaskUnit(
    _StorageSilentActionTaskUnit storageSilentActionTaskUnit,
  ) {
    _xStorage._addStorageSilentActionTaskUnit(storageSilentActionTaskUnit);
  }

  void _addXRootQueueItem({required XRootQueueItem xRootQueueItem}) {
    __xRootQueueItemMap[xRootQueueItem._fullName] = xRootQueueItem;
  }

  // void _addXActivity(XActivity xActivity) {
  //   __xRootQueueItemMap[xActivity._fullName] = xActivity;
  // }
  //
  // void _addXShelf(XShelf xShelf) {
  //   __xRootQueueItemMap[xShelf._fullName] = xShelf;
  // }

  DebugXRootQueue toDebugXRootQueue() {
    return DebugXRootQueue(
      debugXRootQueueItems: __xRootQueueItemMap.entries
          .map((entry) => entry.value.toDebugXRootQueueItem())
          .toList(),
    );
  }

  @override
  String toString() {
    return "XRootQueue: $__xRootQueueItemMap";
  }
}
