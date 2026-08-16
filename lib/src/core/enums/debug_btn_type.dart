import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

enum DebugBtnType {
  success,
  warning,
  error;

  Color getColor(BuildContext context) {
    switch (this) {
      case DebugBtnType.success:
        return context.faColors.action.ink.success;
      case DebugBtnType.warning:
        return context.faColors.action.ink.danger;
      case DebugBtnType.error:
        return context.faColors.action.ink.error;
    }
  }

  static IconData getIconData(DebugBtnType? btnType) {
    switch (btnType) {
      case null:
        return Icons.check_box_outline_blank;
      case DebugBtnType.success:
        return Icons.view_agenda;
      case DebugBtnType.warning:
        return Icons.warning_amber_outlined;
      case DebugBtnType.error:
        return Icons.error_outline;
    }
  }
}
