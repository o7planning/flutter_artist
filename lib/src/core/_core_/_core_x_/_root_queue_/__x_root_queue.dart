part of '../../core.dart';

class _XRootQueue {
  final _xStorage = XStorage();

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

  _ExecutionUnit? getNextExecutionUnit() {
    _ExecutionUnit? tu = _xStorage._getNextExecutionUnit();
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
        return rootQueueItem._getNextExecutionUnit();
      } else if (rootQueueItem is XActivityV1) {
        return rootQueueItem._getNextExecutionUnit();
      } else {
        throw "TODO";
      }
    }
  }

  void _addStorageBackendActionExecutionUnit(
    _StorageBackendActionExecutionUnit storageBackendActionExecutionUnit,
  ) {
    _xStorage._addStorageBackendActionExecutionUnit(storageBackendActionExecutionUnit);
  }

  void _addXRootQueueItem({required XRootQueueItem xRootQueueItem}) {
    __xRootQueueItemMap[xRootQueueItem._fullName] = xRootQueueItem;
  }

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
