part of '../core.dart';

class XStorage {
  _StorageBackendActionTaskUnit? __storageBackendActionTaskUnit;

  bool get isEmpty {
    return __storageBackendActionTaskUnit == null;
  }

  bool get isNotEmpty => !isEmpty;

  void _addStorageBackendActionTaskUnit(
    _StorageBackendActionTaskUnit storageBackendActionTaskUnit,
  ) {
    __storageBackendActionTaskUnit = storageBackendActionTaskUnit;
  }

  _StorageBackendActionTaskUnit? _getNextTaskUnit() {
    _StorageBackendActionTaskUnit? tu = __storageBackendActionTaskUnit;
    __storageBackendActionTaskUnit = null;
    return tu;
  }
}
