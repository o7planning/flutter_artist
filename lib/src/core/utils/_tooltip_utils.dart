import 'package:flutter/material.dart';

class TooltipUtils {
  static Tooltip buildTooltip({
    required String message,
    required Widget child,
  }) {
    return Tooltip(
      textStyle: TextStyle(fontSize: 11.5, color: Colors.white),
      message: "", // message,
      child: child,
    );
  }

  static Tooltip buildCustomTooltip({
    required String message,
    required Widget child,
    double verticalOffset = 18,
  }) {
    return Tooltip(
      textStyle: TextStyle(fontSize: 11.5, color: Colors.white),
      message: "",
      // message,
      verticalOffset: verticalOffset,
      triggerMode: TooltipTriggerMode.manual,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
