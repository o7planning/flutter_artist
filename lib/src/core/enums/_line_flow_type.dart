import 'package:flutter/material.dart';

enum LineFlowType {
  line, // Default.
  info,
  debug,
  addTaskUnit,
  controllableCalling,
  nonControllableCalling,
  fireEvent,
  eventInfo,
  separator;

  String get desc {
    return name;
  }

  IconData getIconData() {
    switch (this) {
      case LineFlowType.line:
        return Icons.backpack_outlined;
      case LineFlowType.info:
        return Icons.info_outline;
      case LineFlowType.controllableCalling:
        return Icons.call;
      case LineFlowType.nonControllableCalling:
        return Icons.call;
      case LineFlowType.addTaskUnit:
        return Icons.miscellaneous_services_outlined;
      case LineFlowType.debug:
        return Icons.bug_report_outlined;

      case LineFlowType.fireEvent:
        return Icons.electric_bolt_outlined;
      case LineFlowType.eventInfo:
        return Icons.electric_bolt_outlined;
      case LineFlowType.separator:
        return Icons.linear_scale;
    }
  }

  Color getIconColor() {
    switch (this) {
      case LineFlowType.line:
        return Colors.black;
      case LineFlowType.info:
        return Colors.cyan;
      case LineFlowType.controllableCalling:
        return Colors.green;
      case LineFlowType.nonControllableCalling:
        return Colors.black87;
      case LineFlowType.addTaskUnit:
        return Colors.orange;
      case LineFlowType.debug:
        return Colors.deepPurpleAccent;
      case LineFlowType.fireEvent:
        return Colors.deepOrange;
      case LineFlowType.eventInfo:
        return Colors.purpleAccent;
      case LineFlowType.separator:
        return Colors.lightBlueAccent;
    }
  }
}
