import 'package:flutter/material.dart';

class DynamicValueView extends StatelessWidget {
  final dynamic value;

  const DynamicValueView({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color bgColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
        : theme.colorScheme.surfaceContainerLow;

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1), width: 0.5),
      ),
      child: SelectableText(
        value == null ? 'null' : value.toString(),
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Courier',
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
