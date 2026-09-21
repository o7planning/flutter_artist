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

  bool hasNext() {
    for (XRootQueueItem item in __xRootQueueItemMap.values) {
      if (item is XShelf) {
        return item._getNextExecutionUnit(debug: false) != null;
      } else if (item is XActivityV1) {
        // return item._getNextExecutionUnit()!= null;
        return true;
      }
    }
    return false;
  }

  _ExecutionUnit? getNextExecutionUnit({required bool removeEmptyRootQuery}) {
    final bool debug = removeEmptyRootQuery;
    final _ExecutionUnit? exeUnit = _xStorage._getNextExecutionUnit(
      remove: removeEmptyRootQuery,
    );
    if (exeUnit != null) {
      return exeUnit;
    }
    final Set<String> rootQueueKeys = __xRootQueueItemMap.keys.toSet();
    while (true) {
      String? firstRootQueueItemName = rootQueueKeys.firstOrNull;
      if (firstRootQueueItemName == null) {
        return null;
      }
      PrintUtils.debug(debug,
          "\n\n------------------------------------------------------------------------------");
      PrintUtils.debug(debug,
          "(***) @FOUND RootQueueName: `$firstRootQueueItemName`  in rootQueueKeys: $rootQueueKeys");

      // XShelf or XActivity:
      final XRootQueueItem rootQueueItem =
          __xRootQueueItemMap[firstRootQueueItemName]!;

      final NxtExecutionUnit? next;
      if (rootQueueItem is XShelf) {
        next = rootQueueItem._getNextExecutionUnit(debug: debug);
      } else if (rootQueueItem is XActivityV1) {
        next = rootQueueItem._getNextExecutionUnit(debug: debug);
      } else {
        throw "TODO getNextExecutionUnit";
      }

      if (next == null) {
        rootQueueKeys.remove(firstRootQueueItemName);
        if (removeEmptyRootQuery) {
          PrintUtils.debug(debug,
              "\n(***) <<< @REMOVE >>> RootQueueName: $firstRootQueueItemName.\n");
          __xRootQueueItemMap.remove(firstRootQueueItemName);
        }
      } else {
        return next.executionUnit!;
      }
    }
  }

  void _addStorageBackendActionExecutionIntent(
    StorageBackendActionIntent executionIntent,
  ) {
    _xStorage._addExecutionIntent(
      executionIntent,
    );
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
