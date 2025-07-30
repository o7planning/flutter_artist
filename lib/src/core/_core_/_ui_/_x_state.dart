part of '../core.dart';

class XState {
  bool _isShowing = false;
  bool _isBuilding = false;

  bool get isShowing => _isShowing;

  bool get isBuilding => _isBuilding;

  void _setShowing(bool isShowing) {
    _isShowing = isShowing;
  }

  void _setBuilding(bool isBuilding) {
    _isBuilding = isBuilding;
  }
}
