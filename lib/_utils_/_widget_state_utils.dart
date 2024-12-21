part of '../flutter_artist.dart';

void _removeUnmountedWidgetStates(Map<_WidgetState, bool> map) {
  for (_WidgetState key in [...map.keys]) {
    if (!key.mounted) {
      map.remove(key);
    }
  }
}
