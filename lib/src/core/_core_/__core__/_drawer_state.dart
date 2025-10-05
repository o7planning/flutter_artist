part of '../core.dart';

class _DrawerCore {
  final _Storage _storage;

  _DrawerCore(_Storage storage) : _storage = storage;
}

class _DrawerState extends _DrawerCore {
  bool _isDrawerOpen = false;

  _DrawerState(super.storage);

  void onDrawerChanged({required bool isOpened}) {
    _isDrawerOpen = isOpened;
  }
}

class _EndDrawerState extends _DrawerCore {
  bool _isEndDrawerOpen = false;

  _EndDrawerState(super.storage);

  void onEndDrawerChanged({required bool isOpened}) {
    _isEndDrawerOpen = isOpened;
  }
}
