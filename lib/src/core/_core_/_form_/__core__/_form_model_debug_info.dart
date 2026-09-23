part of '../../core.dart';

class _FormModelDebugInfo {
  int _loadCount = 0;

  int get loadCount => _loadCount;

  int _saveErrorCount = 0;

  int get saveErrorCount => _saveErrorCount;

  int _formActivityCount = 0;

  int get formActivityCount => _formActivityCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  bool _loadTimeUiActive = false;

  bool get loadTimeUiActive => _loadTimeUiActive;

  _FormModelDebugInfo();
}
