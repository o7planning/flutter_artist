part of '../core.dart';

class _NavigationShowDialogIntent extends NavigationIntent {
  final String path;
  final FaRouteBuilder builder;
  final List<FaRouteGuard> guards;
  final Object? extra;
  final bool barrierDismissible;

  const _NavigationShowDialogIntent(
    this.path, {
    required this.builder,
    this.guards = const [],
    this.extra,
    this.barrierDismissible = true,
    required super.executeOnFailure,
  }) : super._(name: "Open Dialog");
}
