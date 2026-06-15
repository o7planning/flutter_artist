part of '../core.dart';

class _NavigationOpenDrawerIntent extends NavigationIntent {
  const _NavigationOpenDrawerIntent({
    required super.executeOnFailure,
  }) : super._(name: "Open Drawer");
}
