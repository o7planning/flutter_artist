part of '../core.dart';

class XStorage {
  _StorageSilentActionTaskUnit? __storageSilentActionTaskUnit;

  bool get isEmpty {
    return __storageSilentActionTaskUnit == null;
  }

  bool get isNotEmpty => !isEmpty;

  void _addStorageSilentActionTaskUnit(
    _StorageSilentActionTaskUnit storageSilentActionTaskUnit,
  ) {
    __storageSilentActionTaskUnit = storageSilentActionTaskUnit;
  }

  _StorageSilentActionTaskUnit? _getNextTaskUnit() {
    _StorageSilentActionTaskUnit? tu = __storageSilentActionTaskUnit;
    __storageSilentActionTaskUnit = null;
    return tu;
  }
}
