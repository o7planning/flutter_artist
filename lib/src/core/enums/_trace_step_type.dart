import 'package:flutter/material.dart';

enum TraceStepType {
  line, // Default.
  info,
  debug,
  addTaskUnit,
  controllableCalling,
  nonControllableCalling,
  emitEvent,
  eventInfo,
  separator;

  String get desc {
    return name;
  }

  IconData getIconData() {
    switch (this) {
      case TraceStepType.line:
        return Icons.backpack_outlined;
      case TraceStepType.info:
        return Icons.info_outline;
      case TraceStepType.controllableCalling:
        return Icons.call;
      case TraceStepType.nonControllableCalling:
        return Icons.call;
      case TraceStepType.addTaskUnit:
        return Icons.miscellaneous_services_outlined;
      case TraceStepType.debug:
        return Icons.bug_report_outlined;

      case TraceStepType.emitEvent:
        return Icons.electric_bolt_outlined;
      case TraceStepType.eventInfo:
        return Icons.electric_bolt_outlined;
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

      case TraceStepType.addTaskUnit:
        return colorScheme.tertiary;
      case TraceStepType.emitEvent:
        return colorScheme.tertiary;
      case TraceStepType.info:
      case TraceStepType.eventInfo:
        return colorScheme.secondary;

      case TraceStepType.debug:
        return Colors.deepPurpleAccent.withValues(alpha: 0.8);

      case TraceStepType.separator:
        return theme.dividerColor;

      case TraceStepType.nonControllableCalling:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
      case TraceStepType.line:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }
}
