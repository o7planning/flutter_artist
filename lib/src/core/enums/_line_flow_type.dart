import 'package:flutter/material.dart';

enum LineFlowType {
  line, // Default.
  info,
  debug,
  addTaskUnit,
  calling,
  fireEvent;

  IconData getIconData() {
    switch (this) {
      case LineFlowType.line:
        return Icons.backpack_outlined;
      case LineFlowType.info:
        return Icons.info_outline;
      case LineFlowType.calling:
        return Icons.call;
      case LineFlowType.fireEvent:
        return Icons.electric_bolt_outlined;
      case LineFlowType.addTaskUnit:
        return Icons.miscellaneous_services_outlined;
      case LineFlowType.debug:
        return Icons.bug_report_outlined;
    }
  }

  Color getIconColor(bool isLibCall) {
    switch (this) {
      case LineFlowType.line:
        return Colors.black;
      case LineFlowType.info:
        return Colors.cyan;
      case LineFlowType.calling:
        return isLibCall ? Colors.black87 : Colors.green;
      case LineFlowType.fireEvent:
        return Colors.deepOrange;
      case LineFlowType.addTaskUnit:
        return Colors.orange;
      case LineFlowType.debug:
        return Colors.deepPurpleAccent;
    }
  }
}
