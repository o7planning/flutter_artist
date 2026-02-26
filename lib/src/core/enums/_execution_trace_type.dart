import 'package:flutter/material.dart';

enum ExecutionTraceType {
  startup,
  naturalLoad,
  taskUnitCall,
  userMethodCall,
  libMethodCall,
  queuedEvent;

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
      case ExecutionTraceType.queuedEvent:
        return Icons.star;
    }
  }

  Color getIconColor(bool error) {
    if (error) {
      return Colors.red;
    }
    switch (this) {
      case ExecutionTraceType.startup:
        return Colors.black;
      case ExecutionTraceType.naturalLoad:
        return Colors.orange;
      case ExecutionTraceType.taskUnitCall:
        return Colors.indigo;
      case ExecutionTraceType.userMethodCall:
        return Colors.blue;
      case ExecutionTraceType.libMethodCall:
        return Colors.black;
      case ExecutionTraceType.queuedEvent:
        return Colors.deepOrange;
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
      case ExecutionTraceType.queuedEvent:
        return "Init Task Unit for Lazied Events";
    }
  }
}
