import 'package:flutter/material.dart';

enum MasterFlowItemType {
  taskCall,
  methodCall;

  IconData getIconData() {
    switch (this) {
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
      case MasterFlowItemType.taskCall:
        return Colors.indigo;
      case MasterFlowItemType.methodCall:
        return Colors.blue;
    }
  }

  String getTooltipText() {
    switch (this) {
      case MasterFlowItemType.taskCall:
        return "Task Unit.";
      case MasterFlowItemType.methodCall:
        return "Method called by user.";
    }
  }
}
