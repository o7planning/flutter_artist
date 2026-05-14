part of '../core.dart';

class _CustomIntent extends NavigationIntent {
  final void Function(BuildContext context, dynamic result) onExecute;

  const _CustomIntent({
    required this.onExecute,
    required super.executeOnFailure,
  }) : super._();
}
