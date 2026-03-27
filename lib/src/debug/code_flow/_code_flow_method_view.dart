import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';

class CodeFlowMethodView extends StatelessWidget {
  final MethodCallExecutionTrace executionTrace;

  const CodeFlowMethodView({
    super.key,
    required this.executionTrace,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color iconColor = executionTrace.executionTraceType
        .getIconColor(context, executionTrace.hasError());

    return ListTile(
      horizontalTitleGap: 8,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -4,
        vertical: -4,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Icon(
        executionTrace.titleIconData(),
        color: iconColor,
        size: 20,
      ),
      title: SelectableText(
        executionTrace.getTitle(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: SelectableText(
        executionTrace.getSubtitle(),
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'Courier',
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
