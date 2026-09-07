part of '../core.dart';

class XStorage {
  _StorageBackendActionExecutionUnit? __storageBackendActionExecutionUnit;

  bool get isEmpty {
    return __storageBackendActionExecutionUnit == null;
  }

  bool get isNotEmpty => !isEmpty;

  void _addStorageBackendActionExecutionUnit(
    _StorageBackendActionExecutionUnit storageBackendActionExecutionUnit,
  ) {
    __storageBackendActionExecutionUnit = storageBackendActionExecutionUnit;
  }

  _StorageBackendActionExecutionUnit? _getNextExecutionUnit() {
    final tu = __storageBackendActionExecutionUnit;
    __storageBackendActionExecutionUnit = null;
    return tu;
  }
}
