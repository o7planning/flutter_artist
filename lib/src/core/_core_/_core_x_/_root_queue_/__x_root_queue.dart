part of '../../core.dart';

final class _XRootQueue {
  final _xStorage = XStorage();

  ///
  /// LinkedHashMap<String fullName, XRootQueueItem>().
  ///
  /// XRootQueueItem
  ///   │
  ///   ├── XShelf
  ///   │
  ///   └── XActivity
  ///
  final __xRootQueueItemMap = <String, XRootQueueItem>{};

  bool get isEmpty {
    if (_xStorage.isNotEmpty) {
      return false;
    }
    for (XRootQueueItem item in __xRootQueueItemMap.values) {
      if (!item.isEmptyExecutionUnit()) {
        return false;
      }
    }
    return true;
  }

  bool get isNotEmpty => !isEmpty;

  bool hasNext() {
    return isNotEmpty;
  }

  _ExecutionUnit? getNextExecutionUnit() {
    _ExecutionUnit? exeUnit = _xStorage._getNextExecutionUnit();
    if (exeUnit != null) {
      return exeUnit;
    }
    while (true) {
      String? firstRootQueueItemName = __xRootQueueItemMap.keys.firstOrNull;
      if (firstRootQueueItemName == null) {
        return null;
      }
      // XShelf or XActivity:
      final XRootQueueItem rootQueueItem =
          __xRootQueueItemMap[firstRootQueueItemName]!;
      if (rootQueueItem.isEmptyExecutionUnit()) {
        __xRootQueueItemMap.remove(firstRootQueueItemName);
        continue;
      }
      if (rootQueueItem is XShelf) {
        return rootQueueItem._getNextExecutionUnit();
      } else if (rootQueueItem is XActivityV1) {
        return rootQueueItem._getNextExecutionUnit();
      } else {
        throw "TODO getNextExecutionUnit";
      }
    }
  }

  void _addStorageBackendActionExecutionUnit(
    _StorageBackendActionExecutionUnit storageBackendActionExecutionUnit,
  ) {
    _xStorage._addStorageBackendActionExecutionUnit(
        storageBackendActionExecutionUnit);
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
