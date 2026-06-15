part of '../core.dart';

class _NavigationToIntent extends NavigationIntent {
  final String path;
  final FaRouteBuilder? builder;
  final Object? extra;

  const _NavigationToIntent(
    this.path, {
    this.builder,
    this.extra,
    required super.executeOnFailure,
  }) : super._(name: "Navigation To");
}
