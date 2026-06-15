part of '../core.dart';

class _NavigationCustomIntent extends NavigationIntent {
  final void Function(BuildContext context, dynamic result) onExecute;

  const _NavigationCustomIntent({
    required this.onExecute,
    required super.executeOnFailure,
  }) : super._(name: "Custom Intent");
}
