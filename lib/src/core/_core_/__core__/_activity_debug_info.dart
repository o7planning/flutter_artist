part of '../core.dart';

class _ActivityDebugInfo {
  final Activity _activity;

  int _lazyLoadId = 0;

  int get lazyLoadId => _lazyLoadId;

  _ActivityDebugInfo({required Activity activity}) : _activity = activity;
}
