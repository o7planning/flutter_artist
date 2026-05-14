part of '../core.dart';

class _NavigationOffAllIntent extends NavigationIntent {
  final String path;
  final FaRouteBuilder? builder;
  final Object? extra;

  const _NavigationOffAllIntent(
    this.path, {
    this.builder,
    this.extra,
    required super.executeOnFailure,
  }) : super._();
}
