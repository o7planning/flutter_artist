part of '../core.dart';

class XState {
  bool _isVisible = false;
  bool _isBuilding = false;

  bool get isVisible => _isVisible;

  bool get isBuilding => _isBuilding;

  void _setShowing(bool isVisible) {
    _isVisible = isVisible;
  }

  void _setBuilding(bool isBuilding) {
    _isBuilding = isBuilding;
  }
}
