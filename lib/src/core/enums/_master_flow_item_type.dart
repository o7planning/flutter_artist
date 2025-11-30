import 'package:flutter/material.dart';

enum MasterFlowItemType {
  startup,
  naturalUIEvent,
  taskCall,
  methodCall;

  IconData getIconData() {
    switch (this) {
      case MasterFlowItemType.startup:
        return Icons.start;
      case MasterFlowItemType.naturalUIEvent:
        return Icons.event_note_rounded;
      case MasterFlowItemType.taskCall:
        return Icons.miscellaneous_services_outlined;
      case MasterFlowItemType.methodCall:
        return Icons.call;
    }
  }

  Color getIconColor(bool error) {
    if (error) {
      return Colors.red;
    }
    switch (this) {
      case MasterFlowItemType.startup:
        return Colors.black;
      case MasterFlowItemType.naturalUIEvent:
        return Colors.orange;
      case MasterFlowItemType.taskCall:
        return Colors.indigo;
      case MasterFlowItemType.methodCall:
        return Colors.blue;
    }
  }

  String getTooltipText() {
    switch (this) {
      case MasterFlowItemType.startup:
        return "Startup";
      case MasterFlowItemType.naturalUIEvent:
        return "Detect newly displayed UI Component";
      case MasterFlowItemType.taskCall:
        return "Task Unit.";
      case MasterFlowItemType.methodCall:
        return "Method called by user";
    }
  }
}
