import 'package:flutter/material.dart';

enum MasterFlowItemType {
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
      case MasterFlowItemType.startup:
        return Icons.start;
      case MasterFlowItemType.naturalLoad:
        return Icons.event_note_rounded;
      case MasterFlowItemType.taskUnitCall:
        return Icons.miscellaneous_services_outlined;
      case MasterFlowItemType.userMethodCall:
        return Icons.call;
      case MasterFlowItemType.libMethodCall:
        return Icons.call;
      case MasterFlowItemType.queuedEvent:
        return Icons.star;
    }
  }

  Color getIconColor(bool error) {
    if (error) {
      return Colors.red;
    }
    switch (this) {
      case MasterFlowItemType.startup:
        return Colors.black;
      case MasterFlowItemType.naturalLoad:
        return Colors.orange;
      case MasterFlowItemType.taskUnitCall:
        return Colors.indigo;
      case MasterFlowItemType.userMethodCall:
        return Colors.blue;
      case MasterFlowItemType.libMethodCall:
        return Colors.black;
      case MasterFlowItemType.queuedEvent:
        return Colors.deepOrange;
    }
  }

  String getTooltipText() {
    switch (this) {
      case MasterFlowItemType.startup:
        return "Startup";
      case MasterFlowItemType.naturalLoad:
        return "Detect newly displayed UI Component";
      case MasterFlowItemType.taskUnitCall:
        return "Task Unit.";
      case MasterFlowItemType.userMethodCall:
        return "User's Method";
      case MasterFlowItemType.libMethodCall:
        return "Lib's Method";
      case MasterFlowItemType.queuedEvent:
        return "Init Task Unit for Lazied Events";
    }
  }
}
