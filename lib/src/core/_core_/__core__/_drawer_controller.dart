part of '../core.dart';

abstract class _DrawerCtrl {
  final _Storage _storage;

  bool get isOpen;

  void updateStatus({required bool opened});

  _DrawerCtrl(_Storage storage) : _storage = storage;
}

class _DrawerController extends _DrawerCtrl {
  bool _isDrawerOpen = false;

  @override
  bool get isOpen => _isDrawerOpen;

  _DrawerController(super.storage);

  @override
  void updateStatus({required bool opened}) {
    _isDrawerOpen = opened;
  }
}

class _EndDrawerController extends _DrawerCtrl {
  bool _isEndDrawerOpen = false;

  @override
  bool get isOpen => _isEndDrawerOpen;

  _EndDrawerController(super.storage);

  @override
  void updateStatus({required bool opened}) {
    _isEndDrawerOpen = opened;
  }
}
