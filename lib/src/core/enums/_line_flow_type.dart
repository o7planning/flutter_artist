import 'package:flutter/material.dart';

enum LineFlowType {
  line, // Default.
  info,
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
        return Icons.light_mode_outlined;
    }
  }

  Color getIconColor() {
    switch (this) {
      case LineFlowType.line:
        return Colors.black;
      case LineFlowType.info:
        return Colors.cyan;
      case LineFlowType.calling:
        return Colors.green;
      case LineFlowType.fireEvent:
        return Colors.deepOrange;
    }
  }
}
