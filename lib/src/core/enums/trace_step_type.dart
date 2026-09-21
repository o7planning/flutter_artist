import 'package:flutter/material.dart';

/// Categorizes the operational intent and lifecycle scope of individual trace steps.
enum TraceStepType {
  /// Controllable method invocation that can be overridden or defined by developers (e.g., performQuery, performDeleteItemById).
  controllableCalling,

  /// Internal library/engine method call governing framework coordination (e.g., _updateBlockSyncSessionState).
  nonControllableCalling,

  /// Execution intent creation or scheduler queue transition.
  executionIntent,

  /// Domain-level event emitted or received across shelves and components.
  broadcastEvent,

  /// Informational payload, calculation metrics, diagnostic state snapshots, or precheck evaluations.
  info,

  /// Visual division separating logical operational phases.
  separator;

  String get desc => name;

  IconData getIconData() {
    switch (this) {
      case TraceStepType.controllableCalling:
      case TraceStepType.nonControllableCalling:
        return Icons.call;
      case TraceStepType.executionIntent:
        return Icons.add_to_drive_outlined;
      case TraceStepType.broadcastEvent:
        return Icons.electric_bolt_outlined;
      case TraceStepType.info:
        return Icons.info_outline;
      case TraceStepType.separator:
        return Icons.linear_scale;
    }
  }

  Color getIconColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (this) {
      case TraceStepType.controllableCalling:
        return colorScheme.primary;
      case TraceStepType.nonControllableCalling:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
      case TraceStepType.executionIntent:
      case TraceStepType.broadcastEvent:
        return colorScheme.tertiary;
      case TraceStepType.info:
        return colorScheme.secondary;
      case TraceStepType.separator:
        return theme.dividerColor;
    }
  }
}
