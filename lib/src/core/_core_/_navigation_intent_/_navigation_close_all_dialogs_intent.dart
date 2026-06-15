part of '../core.dart';

class _NavigationCloseAllDialogsIntent extends NavigationIntent {
  const _NavigationCloseAllDialogsIntent({
    required super.executeOnFailure,
  }) : super._(name: "Close All Dialogs");
}
