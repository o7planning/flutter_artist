part of '../core.dart';

class _NavigationOffIntent extends NavigationIntent {
  final String path;
  final FaRouteBuilder? builder;
  final Object? extra;

  const _NavigationOffIntent(
    this.path, {
    this.builder,
    this.extra,
    required super.executeOnFailure,
  }) : super._(name: "Navigation Off");
}
