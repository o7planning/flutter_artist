import 'package:flutter/material.dart';

enum ExecutionTraceType {
  startup,
  naturalLoad,
  taskUnitCall,
  userMethodCall,
  libMethodCall,
  deferredEvent;

  String get desc {
    return name;
  }

  IconData getIconData() {
    switch (this) {
      case ExecutionTraceType.startup:
        return Icons.start;
      case ExecutionTraceType.naturalLoad:
        return Icons.event_note_rounded;
      case ExecutionTraceType.taskUnitCall:
        return Icons.miscellaneous_services_outlined;
      case ExecutionTraceType.userMethodCall:
        return Icons.call;
      case ExecutionTraceType.libMethodCall:
        return Icons.call;
      case ExecutionTraceType.deferredEvent:
        return Icons.star;
    }
  }

  Color getIconColor(BuildContext context, bool error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (error) {
      return colorScheme.error;
    }

    switch (this) {
      case ExecutionTraceType.userMethodCall:
        return colorScheme.primary;
      case ExecutionTraceType.taskUnitCall:
        return colorScheme.tertiary;
      case ExecutionTraceType.naturalLoad:
        return colorScheme.secondary;
      case ExecutionTraceType.deferredEvent:
        return Colors.orangeAccent;
      case ExecutionTraceType.startup:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
      case ExecutionTraceType.libMethodCall:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  String getTooltipText() {
    switch (this) {
      case ExecutionTraceType.startup:
        return "Startup";
      case ExecutionTraceType.naturalLoad:
        return "Detect newly displayed UI Component";
      case ExecutionTraceType.taskUnitCall:
        return "Task Unit.";
      case ExecutionTraceType.userMethodCall:
        return "User's Method";
      case ExecutionTraceType.libMethodCall:
        return "Lib's Method";
      case ExecutionTraceType.deferredEvent:
        return "Init Task Unit for Deferred Events";
    }
  }
}
