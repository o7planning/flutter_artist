part of '../core.dart';

class _FilterModelDebugInfo {
  int _loadCount = 0;

  int get loadCount => _loadCount;

  int _filterActivityCount = 0;

  int get filterActivityCount => _filterActivityCount;

  bool _loadTimeUiActive = false;

  bool get loadTimeUiActive => _loadTimeUiActive;

  _FilterModelDebugInfo();
}
